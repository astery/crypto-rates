defmodule CryptoRatesWeb.RatesChannelTest do
  use CryptoRatesWeb.ChannelCase
  alias CryptoRatesWeb.RatesChannel

  alias CryptoRates.{
    Rate,
    Rates
  }
  alias CryptoRatesWeb.UserSocket

  test "should receive all rates saves" do
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, "rates", %{})

    rates = [%Rate{from: "BTC", to: "USD", rate: 10.0, at: from_naive!(~N[2018-01-01 02:00:00.000000])}]
    :ok = Rates.save_rates(rates)

    assert_broadcast("crypto_rates", %{rates: ^rates})
  end
end
