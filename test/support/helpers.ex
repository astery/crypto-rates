defmodule CryptoRates.Support.Helpers do
  def from_naive!(datetime), do: DateTime.from_naive!(datetime, "Etc/UTC")
end
