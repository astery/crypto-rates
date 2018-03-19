use Mix.Config

config :crypto_rates, :fetcher, CryptoCurrenciesFetcher
config :crypto_rates, :update_period, 1000
config :crypto_rates, CryptoRates.Rates,
  adapter: Sqlite.Ecto2,
  database: "db.dev.sqlite"

config :crypto_rates, CryptoRatesWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
