use Mix.Config

config :crypto_rates, ecto_repos: [CryptoRates.Rates]

import_config "#{Mix.env()}.exs"
