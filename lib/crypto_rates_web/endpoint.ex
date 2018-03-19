defmodule CryptoRatesWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :crypto_rates

  socket "/socket", CryptoRatesWeb.UserSocket

  plug Plug.Static.IndexHtml, at: "/"
  plug Plug.Static,
    at: "/", from: :crypto_rates, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt index.html)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug CryptoRatesWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
