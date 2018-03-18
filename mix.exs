defmodule CryptoRates.Mixfile do
  use Mix.Project

  def project do
    [app: :crypto_rates,
     version: "0.0.1",
     elixir: "~> 1.6",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {CryptoRates, []}]
  end

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:sqlite_ecto2, "~> 2.2"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
    ]
  end
end
