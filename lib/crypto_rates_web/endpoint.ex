defmodule CryptoRatesWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :crypto_rates

  socket "/socket", CryptoRatesWeb.UserSocket

  plug :assign_config_options

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

  defp assign_config_options(conn, _opts) do
    conn
    |> put_private_new(:crypto_rates_current_time_fn, &DateTime.utc_now/0)
    |> put_private_new(:crypto_rates_calc_rate, &CryptoRates.Rates.convert/4)
  end

  defp put_private_new(%{private: p} = conn, key, value) do
    if p[key] do
      conn
    else
      conn
      |> put_private(key, value)
    end
  end
end
