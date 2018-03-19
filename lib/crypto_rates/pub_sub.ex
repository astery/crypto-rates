defmodule CryptoRates.PubSub do
  def start_link(_) do
    Registry.start_link(
      keys: :duplicate,
      name: __MODULE__,
      partitions: System.schedulers_online
    )
  end

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [[]]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def subscribe do
    Registry.register(__MODULE__, "rates", [])
  end

  @spec notify([CryptoRates.Rate.t]) :: :ok
  def notify(rates) do
    Registry.dispatch(__MODULE__, "rates", fn entries ->
      for {pid, _} <- entries, do: send(pid, {:crypto_rates, rates})
    end)
  end
end
