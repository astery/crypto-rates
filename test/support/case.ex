defmodule CryptoRates.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import CryptoRates.Case
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoRates.Rates)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CryptoRates.Rates, {:shared, self()})
    end
  end

  def from_naive!(datetime), do: DateTime.from_naive!(datetime, "Etc/UTC")
end
