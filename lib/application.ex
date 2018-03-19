defmodule CryptoRates.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      CryptoRates.Rates,
      CryptoRates.PubSub,
      supervisor(CryptoRatesWeb.Endpoint, []),
      CryptoRatesWeb.RatesChannel.Broadcaster,
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
        start: {PeriodicalRunner, :start_link, [&CryptoRates.update_rates/0, update_period]}
      }
    )
  end

  def terminate_periodical_runner do
    Supervisor.terminate_child(CryptoRates.Supervisor, PeriodicalRunner)
  end
end
