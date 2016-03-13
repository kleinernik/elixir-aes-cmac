defmodule Aescmac do
  use Bitwise

  @const_Zero <<0x00000000000000000000000000000000::128>>
  @const_Rb <<0x00000000000000000000000000000087::128>>
  @const_Bsize 16


  @doc """
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +                    Algorithm Generate_Subkey                      +
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +                                                                   +
  +   Input    : K (128-bit key)                                      +
  +   Output   : K1 (128-bit first subkey)                            +
  +              K2 (128-bit second subkey)                           +
  +-------------------------------------------------------------------+
  +                                                                   +
  +   Constants: const_Zero is 0x00000000000000000000000000000000     +
  +              const_Rb   is 0x00000000000000000000000000000087     +
  +   Variables: L          for output of AES-128 applied to 0^128    +
  +                                                                   +
  +   Step 1.  L := AES-128(K, const_Zero);                           +
  +   Step 2.  if MSB(L) is equal to 0                                +
  +            then    K1 := L << 1;                                  +
  +            else    K1 := (L << 1) XOR const_Rb;                   +
  +   Step 3.  if MSB(K1) is equal to 0                               +
  +            then    K2 := K1 << 1;                                 +
  +            else    K2 := (K1 << 1) XOR const_Rb;                  +
  +   Step 4.  return K1, K2;                                         +
  +                                                                   +
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  """
  def generate_subkeys(<<_::128>>=k) do
    l = :crypto.block_encrypt(:aes_ecb, k, @const_Zero)
    k1 = case l do
      <<0::1, rest::127>> ->  <<(rest<<<1)::128>>
      <<1::1, rest::127>> -> :crypto.exor(<<(rest<<<1)::128>>, @const_Rb)
    end
    k2 = case k1 do
      <<0::1, rest::127>> ->  <<(rest<<<1)::128>>
      <<1::1, rest::127>> -> :crypto.exor(<<(rest<<<1)::128>>, @const_Rb)
    end
    {k1, k2}
  end

  @doc """
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +                   Algorithm AES-CMAC                              +
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +                                                                   +
  +   Input    : K    ( 128-bit key )                                 +
  +            : M    ( message to be authenticated )                 +
  +            : len  ( length of the message in octets )             +
  +   Output   : T    ( message authentication code )                 +
  +                                                                   +
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +   Constants: const_Zero is 0x00000000000000000000000000000000     +
  +              const_Bsize is 16                                    +
  +                                                                   +
  +   Variables: K1, K2 for 128-bit subkeys                           +
  +              M_i is the i-th block (i=1..ceil(len/const_Bsize))   +
  +              M_last is the last block xor-ed with K1 or K2        +
  +              n      for number of blocks to be processed          +
  +              r      for number of octets of last block            +
  +              flag   for denoting if last block is complete or not +
  +                                                                   +
  +   Step 1.  (K1,K2) := Generate_Subkey(K);                         +
  +   Step 2.  n := ceil(len/const_Bsize);                            +
  +   Step 3.  if n = 0                                               +
  +            then                                                   +
  +                 n := 1;                                           +
  +                 flag := false;                                    +
  +            else                                                   +
  +                 if len mod const_Bsize is 0                       +
  +                 then flag := true;                                +
  +                 else flag := false;                               +
  +                                                                   +
  +   Step 4.  if flag is true                                        +
  +            then M_last := M_n XOR K1;                             +
  +            else M_last := padding(M_n) XOR K2;                    +
  +   Step 5.  X := const_Zero;                                       +
  +   Step 6.  for i := 1 to n-1 do                                   +
  +                begin                                              +
  +                  Y := X XOR M_i;                                  +
  +                  X := AES-128(K,Y);                               +
  +                end                                                +
  +            Y := M_last XOR X;                                     +
  +            T := AES-128(K,Y);                                     +
  +   Step 7.  return T;                                              +
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  """
  def aes_cmac(<<_::128>>=k, m) do
    {k1, k2} = generate_subkeys(k)
    calc(m, {k, k1, k2})
  end

  defp calc(m, {k, k1, k2}) do
    _calc(m, {k, k1, k2}, @const_Zero)
  end

  defp _calc(<<m::binary-size(@const_Bsize)>>, {k, k1, k2}, x) do
    m = :crypto.exor(m, k1)
    y = :crypto.exor(m, x)
    :crypto.block_encrypt(:aes_ecb, k, y)
  end

  defp _calc(<<m::binary-size(@const_Bsize), rest::binary>>, {k, k1, k2}, x) do
    y = :crypto.exor(x, m)
    x = :crypto.block_encrypt(:aes_ecb, k, y)
    _calc(rest, {k, k1, k2}, x)
  end

  defp _calc(<<m::binary>>, {k, k1, k2}, x) do
    padding_size = 128-bit_size(m)-1
    m = :crypto.exor(m <> <<1::1, 0::size(padding_size)>>, k2)
    y = :crypto.exor(m, x)
    :crypto.block_encrypt(:aes_ecb, k, y)
  end

end
