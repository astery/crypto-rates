defmodule CryptoRates.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import CryptoRates.Case
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoRates.Rates)
  end

  def from_naive!(datetime), do: DateTime.from_naive!(datetime, "Etc/UTC")
end
