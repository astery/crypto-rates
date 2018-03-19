defmodule CryptoRatesWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest
      import CryptoRates.Support.Helpers

      # The default endpoint for testing
      @endpoint CryptoRatesWeb.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoRates.Rates)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CryptoRates.Rates, {:shared, self()})
    end
  end
end
