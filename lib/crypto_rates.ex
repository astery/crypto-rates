defmodule CryptoRates do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      CryptoRates.Rates,
      CryptoRates.PubSub,
      supervisor(CryptoRatesWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: CryptoRates.Supervisor]
    start = Supervisor.start_link(children, opts)

    if Application.get_env(:crypto_rates, :start_periodical_runner, false) do
      start_periodical_runner()
    end

    start
  end

  def start_periodical_runner do
    update_period = Application.get_env(:crypto_rates, :update_period, 1000)

    Supervisor.start_child(
      CryptoRates.Supervisor,
      %{
        id: PeriodicalRunner,
        start: {PeriodicalRunner, :start_link, [&update_rates/0, update_period]}
      }
    )
  end

  def terminate_periodical_runner do
    Supervisor.terminate_child(CryptoRates.Supervisor, PeriodicalRunner)
  end

  @from ["BTC", "ETH"]
  @to ["USD", "EUR"]

  defp update_rates() do
    @from
    |> Enum.map(&get_rates_task/1)
    |> Enum.map(&Task.await/1)
    |> Enum.flat_map(fn
      {:ok, rates} -> rates
      :error -> []
    end)
    |> CryptoRates.Rates.save_rates()
  end

  defp get_rates_task(from) do
    fetcher = Application.get_env(:crypto_rates, :fetcher, CryptoCurrenciesFetcher)

    Task.async(fn -> fetcher.get_rates(from, @to) end)
  end

  def config_change(changed, _new, removed) do
    CryptoRatesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
