defmodule CryptoRates.Fetcher do
  @callback get_rates(String.t, [String.t], (() -> DateTime.t)) :: {:ok, [Rate.t]} | :error
end
