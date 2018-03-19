defmodule CryptoRates.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import CryptoRates.Support.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoRates.Rates)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CryptoRates.Rates, {:shared, self()})
    end
  end
end
