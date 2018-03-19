defmodule CryptoRatesWeb.RatesChannel do
  use Phoenix.Channel

  defmodule Broadcaster do
    use GenServer, start: {__MODULE__, :start_link, []}

    def start_link do
      GenServer.start_link(__MODULE__, [])
    end

    def init(_args) do
      CryptoRates.PubSub.subscribe
      {:ok, []}
    end

    def broadcast(rates) do
      CryptoRatesWeb.Endpoint.broadcast("rates", "crypto_rates", %{rates: rates})
    end

    def handle_info({:crypto_rates, rates}, state) do
      broadcast(rates)
      {:noreply, state}
    end
  end

  def join("rates", _message, socket) do
    {:ok, socket}
  end
end
