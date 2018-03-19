defmodule CryptoRates.Mixfile do
  use Mix.Project

  def project do
    [
      app: :crypto_rates,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: ["cr.start": "phx.server"],
    ]
  end

  def application do
    [
      mod: {CryptoRates.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:sqlite_ecto2, "~> 2.2"},
      {:poison, "~> 3.1"},

      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:plug_static_index_html, "~> 1.0"},

      {:exvcr, "~> 0.10", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
    ]
  end
end
