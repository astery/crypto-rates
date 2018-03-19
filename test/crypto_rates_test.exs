defmodule CryptoRatesTest do
  use CryptoRates.Case

  @tags [:external]
  test "should begin to receiving rates every 100 ms" do
    CryptoRates.subscribe(self())
    assert_receive({:crypto_rates, _rates}, 120)
    refute_receive({:crypto_rates, _rates}, 100)
    assert_receive({:crypto_rates, _rates}, 120)
  end
end
