use Mix.Config

config :crypto_rates, :fetcher, CryptoRates.StubbedFetcher
config :crypto_rates, :update_period, 100
config :crypto_rates, :start_periodical_runner, false
config :crypto_rates, CryptoRates.Rates,
  adapter: Sqlite.Ecto2,
  database: "db.test.sqlite",
  pool: Ecto.Adapters.SQL.Sandbox

config :crypto_rates, CryptoRatesWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
