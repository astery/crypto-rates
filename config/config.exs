use Mix.Config

config :crypto_rates, ecto_repos: [CryptoRates.Rates]
config :crypto_rates, CryptoRatesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8tJitWM8zW0cKtAcHoA96kXb4xrEFxQF2FK39nIdRY557WVAyg+TXlv2x/ju4E2i",
  render_errors: [view: CryptoRatesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CryptoRatesWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

import_config "#{Mix.env()}.exs"
