defmodule Aescmac.Mixfile do
  use Mix.Project

  def project do
    [app: :aescmac,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package()
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end


  defp package do
  [
    maintainers: ["Niklas Klein"],
    description: "AES CMAC (rfc 4493) in Elixir",
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/kleinernik/elixir-aes-cmac"},
    files: ["config", "lib", "test", "mix.exs", "README*", "LICENSE*", "rfc4493.txt"],
  ]
  end


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
