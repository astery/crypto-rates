defmodule CryptoRatesWeb.RatesChannel do
  use Phoenix.Channel

  defmodule Broadcaster do
    use GenServer, start: {__MODULE__, :start_link, []}

    def start_link do
      GenServer.start_link(__MODULE__, [])
    end

    def set_broadcast_date(""), do: set_broadcast_date(nil)
    def set_broadcast_date(date) do
      GenServer.cast(__MODULE__, {:set_broadcast_date, date})
      CryptoRatesWeb.Endpoint.broadcast("rates", "broadcast_date_set", %{date: date})
    end

    def init(_args) do
      CryptoRates.PubSub.subscribe
      {:ok, %{broadcast?: true}}
    end

    def handle_cast({:set_broadcast_date, nil}, state) do
      broadcast(CryptoRates.Rates.all_rates_by_nearest_time(DateTime.utc_now))
      {:noreply, %{state | broadcast?: true}}
    end
    def handle_cast({:set_broadcast_date, date}, state) do
      broadcast(CryptoRates.Rates.all_rates_by_nearest_time(date))
      {:noreply, %{state | broadcast?: false}}
    end

    def handle_info({:crypto_rates, rates}, state) do
      if state.broadcast?, do: broadcast(rates)
      {:noreply, state}
    end

    defp broadcast(rates) do
      CryptoRatesWeb.Endpoint.broadcast("rates", "crypto_rates", %{rates: rates})
    end
  end

  def join("rates", _message, socket) do
    {:ok, socket}
  end

  def handle_in("set_broadcast_date", %{"date" => date}, socket) do
    case DateTime.from_iso8601(date) do
      {:ok, dt, _} -> Broadcaster.set_broadcast_date(dt)
      _ -> nil
    end
    {:noreply, socket}
  end
end
