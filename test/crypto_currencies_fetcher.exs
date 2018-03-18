defmodule CryptoCurrenciesFetcherTest do
  use CryptoRates.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias CryptoRates.{
    Rate,
  }

  setup do
    %{current_time: from_naive!(~N[2018-01-01 00:00:00.000000])}
  end

  describe "service answers with data" do
    test "should return rates", %{current_time: current_time} do
      use_cassette "crypto_currencies_good" do
        assert {:ok, [
          %Rate{from: "BTC", to: "USD", rate: 10.0, at: current_time},
          %Rate{from: "BTC", to: "EUR", rate: 10.0, at: current_time},
        ]} == CryptoCurrenciesFetcher.get_rates("BTC", ["USD", "EUR"], fn -> current_time end)
      end
    end
  end

  describe "service answers with error" do
    test "should return error", %{current_time: current_time} do
      use_cassette "crypto_currencies_404" do
        assert :error == CryptoCurrenciesFetcher.get_rates("BTC", ["USD", "EUR"], fn -> current_time end)
      end
    end
  end

  # TODO: service hangs while connection open
end
