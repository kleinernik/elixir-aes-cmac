# Aescmac

Implementation of rfc4493 in elixir using :crypto from erlang for aes.

All tests from rfc4493 passing.

Aescmac.aes_cmac takes two binaries, the key and the message, where the key has to be 128bit

Usage example:
#  Aescmac.aes_cmac(key, message)
<<0x070a16b4_6b4d4144_f79bdd9d_d04a287c::128>> = Aescmac.aes_cmac(<<0x2b7e1516_28aed2a6_abf71588_09cf4f3c::128>>,<<0x6bc1bee2_2e409f96_e93d7e11_7393172a::128>>)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add aescmac to your list of dependencies in `mix.exs`:

        def deps do
          [{:aescmac, "~> 0.0.1"}]
        end

  2. Ensure aescmac is started before your application:

        def application do
          [applications: [:aescmac]]
        end
