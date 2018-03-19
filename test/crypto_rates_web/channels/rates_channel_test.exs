defmodule CryptoRatesWeb.RatesChannelTest do
  use CryptoRatesWeb.ChannelCase

  alias CryptoRates.{
    Rate,
    Rates
  }
  alias CryptoRatesWeb.UserSocket

  setup do
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, "rates", %{})
    %{socket: socket}
  end

  @tag :skip # pending
  test "should receive all rates saves before broadcast date was set", %{socket: socket} do
    first_rates = [
      %Rate{from: "BTC", to: "USD", rate: 10.0, at: from_naive!(~N[2018-01-01 00:00:00.000000])},
      %Rate{from: "ETH", to: "USD", rate: 10.0, at: from_naive!(~N[2018-01-01 00:00:00.000000])},
    ]
    :ok = Rates.save_rates(first_rates)
    assert_broadcast("crypto_rates", %{rates: ^first_rates})

    second_rates = [
      %Rate{from: "BTC", to: "USD", rate: 20.0, at: from_naive!(~N[2018-01-01 01:00:00.000000])},
      %Rate{from: "ETH", to: "USD", rate: 20.0, at: from_naive!(~N[2018-01-01 01:00:00.000000])},
    ]
    :ok = Rates.save_rates(second_rates)
    assert_broadcast("crypto_rates", %{rates: ^second_rates})

    # should receive nearest rates
    date = from_naive!(~N[2018-01-01 01:00:00.000000])
    push socket, "set_broadcast_date", %{"date" => DateTime.to_string(date)}
    assert_broadcast("broadcast_date_set", %{date: ^date})
    assert_broadcast("crypto_rates", %{rates: ^first_rates})

    # should stay mute
    third_rates = [
      %Rate{from: "BTC", to: "USD", rate: 30.0, at: from_naive!(~N[2018-01-01 02:00:00.000000])},
      %Rate{from: "ETH", to: "USD", rate: 30.0, at: from_naive!(~N[2018-01-01 02:00:00.000000])},
    ]
    :ok = Rates.save_rates(second_rates)
    refute_broadcast("crypto_rates", %{rates: ^third_rates})

    # should continue receive rate saves
    push socket, "set_broadcast_date", %{"date" => ""}
    assert_broadcast("broadcast_date_set", %{date: ""})
    assert_broadcast("crypto_rates", %{rates: ^third_rates})
  end
end
