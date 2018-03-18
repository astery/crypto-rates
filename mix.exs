defmodule CryptoRates.Mixfile do
  use Mix.Project

  def project do
    [app: :crypto_rates,
     version: "0.0.1",
     elixir: "~> 1.6",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {CryptoRates, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:sqlite_ecto2, "~> 2.2"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.10", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
    ]
  end
end
