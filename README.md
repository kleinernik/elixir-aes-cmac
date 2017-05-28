# Hint for users of OTP >= 20

Since OTP 20 the AES-CMAC is in `:crypto`

You can simply use for example:

```elixir
:crypto.cmac :"aes_cbc128", <<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,<<0x6bc1bee2_2e409f96_e93d7e11_7393172a_ae2d8a57_1e03ac9c_9eb76fac_45af8e51_30c81c46_a35ce411::320>>
```
See in [Erlang sources](https://github.com/erlang/otp/blob/83e20c62057ebc1d8064bf57b01be560cd244e1d/lib/crypto/src/crypto.erl#L159)


# Aescmac

Implementation of [rfc4493](https://tools.ietf.org/html/rfc4493) in elixir using :crypto from erlang for aes.

All [tests from rfc4493](https://tools.ietf.org/html/rfc4493#page-11) passing.

Aescmac.aes_cmac takes two binaries, the key and the message, where the key has to be 128bit

Usage example:

```elixir
#  Aescmac.aes_cmac(key, message)
<<0x070a16b4_6b4d4144_f79bdd9d_d04a287c::128>> = Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,<<0x6bc1bee2_2e409f96_e93d7e11_7393172a::128>>)
```

## Documentation

Docs can be found [at hexdocs.pm](https://hexdocs.pm/aescmac/).

## Installation

[Available in Hex](https://hex.pm/packages/aescmac), the package can be installed with:

  1. Add aescmac to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:aescmac, "~> 0.0.1"}]
    end
    ```

  2. Ensure aescmac is started before your application:

    ```elixir
    def application do
      [applications: [:aescmac]]
    end
    ```
