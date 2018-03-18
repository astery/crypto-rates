defmodule CryptoRates do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      CryptoRates.Rates,
    ]

    opts = [strategy: :one_for_one, name: CryptoRates.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
