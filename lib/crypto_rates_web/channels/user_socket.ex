defmodule CryptoRatesWeb.UserSocket do
  use Phoenix.Socket

  channel "rates", CryptoRatesWeb.RatesChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
