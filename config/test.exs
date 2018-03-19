use Mix.Config

config :crypto_rates, :fetcher, CryptoRates.StubbedFetcher
config :crypto_rates, :update_period, 100
config :crypto_rates, CryptoRates.Rates,
  adapter: Sqlite.Ecto2,
  database: "db.test.sqlite",
  pool: Ecto.Adapters.SQL.Sandbox

