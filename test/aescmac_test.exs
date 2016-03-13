defmodule AescmacTest do
  use ExUnit.Case
  doctest Aescmac

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "subkey generation" do
    assert {<<0xfbeed618_35713366_7c85e08f_7236a8de::128>>, <<0xf7ddac30_6ae266cc_f90bc11e_e46d513b::128>>} = Aescmac.generate_subkeys(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>)
  end

  @doc ~S"""
  --------------------------------------------------
  Example 1: len = 0
  M              <empty string>
  AES-CMAC       bb1d6929 e9593728 7fa37d12 9b756746
  --------------------------------------------------
  """
  test "empty string" do
    assert <<0xbb1d6929_e9593728_7fa37d12_9b756746::128>> = Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,"")
  end

  @doc """
  Example 2: len = 16
  M              6bc1bee2 2e409f96 e93d7e11 7393172a
  AES-CMAC       070a16b4 6b4d4144 f79bdd9d d04a287c
  """
  test "len = 16" do
    assert <<0x070a16b4_6b4d4144_f79bdd9d_d04a287c::128>> = Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,<<0x6bc1bee2_2e409f96_e93d7e11_7393172a::128>>)
  end

  @doc ~S"""
  Example 3: len = 40
  M              6bc1bee2 2e409f96 e93d7e11 7393172a
                 ae2d8a57 1e03ac9c 9eb76fac 45af8e51
                 30c81c46 a35ce411
  AES-CMAC       dfa66747 de9ae630 30ca3261 1497c827
  """
  test "len = 40" do
    assert <<0xdfa66747_de9ae630_30ca3261_1497c827::128>> =
      Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,<<0x6bc1bee2_2e409f96_e93d7e11_7393172a_ae2d8a57_1e03ac9c_9eb76fac_45af8e51_30c81c46_a35ce411::320>>)
  end

  @doc ~S"""
  Example 4: len = 64
  M              6bc1bee2 2e409f96 e93d7e11 7393172a
                 ae2d8a57 1e03ac9c 9eb76fac 45af8e51
                 30c81c46 a35ce411 e5fbc119 1a0a52ef
                 f69f2445 df4f9b17 ad2b417b e66c3710
  AES-CMAC       51f0bebf 7e3b9d92 fc497417 79363cfe
  """
  test "len = 64" do
    assert <<0x51f0bebf_7e3b9d92_fc497417_79363cfe::128>> =
      Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,
      <<0x6bc1bee2_2e409f96_e93d7e11_7393172a_ae2d8a57_1e03ac9c_9eb76fac_45af8e51_30c81c46_a35ce411_e5fbc119_1a0a52ef_f69f2445_df4f9b17_ad2b417b_e66c3710::512>>)
  end
end
