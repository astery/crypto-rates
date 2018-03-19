use Mix.Config

config :crypto_rates, :fetcher, CryptoCurrenciesFetcher
config :crypto_rates, :update_period, 1000
config :crypto_rates, CryptoRates.Rates,
  adapter: Sqlite.Ecto2,
  database: "db.dev.sqlite"
