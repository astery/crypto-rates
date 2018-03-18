defmodule CryptoRates.RatesTest do
  use ExUnit.Case

  alias CryptoRates.{
    Rate,
    Rates,
  }

  describe "empty store" do
    test "should return nil" do
      assert nil == Rates.get_single_rate_by_nearest_time("BTC", "USD", DateTime.utc_now)
    end
  end

  describe "store filled with fixture data" do
    setup do
      rates = [
        %Rate{from: "BTC", to: "USD", rate: 10.0, at: from_naive!(~N[2018-01-01 00:00:00.000000])},
        %Rate{from: "ETH", to: "USD", rate: 20.0, at: from_naive!(~N[2018-01-01 00:00:00.000000])},
        %Rate{from: "BTC", to: "USD", rate: 11.0, at: from_naive!(~N[2018-01-01 01:00:00.000000])},
      ]
      :ok = Rates.save_rates(rates)
      %{rates: rates}
    end

    test "should return nearest rate to date", %{rates: [first, _, third]} do
      assert ^first = Rates.get_single_rate_by_nearest_time("BTC", "USD", from_naive!(~N[2017-01-01 00:00:00.0]))
      assert ^first = Rates.get_single_rate_by_nearest_time("BTC", "USD", from_naive!(~N[2018-01-01 00:30:00.0]))
      assert ^third = Rates.get_single_rate_by_nearest_time("BTC", "USD", from_naive!(~N[2018-01-01 00:31:00.0]))
    end
  end

  # TODO: replace
  def from_naive!(datetime), do: DateTime.from_naive!(datetime, "Etc/UTC")
end