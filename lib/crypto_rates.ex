defmodule CryptoRates do
  @from ["BTC", "ETH"]
  @to ["USD", "EUR"]

  def from_currencies, do: @from
  def to_currencies, do: @to

  def update_rates() do
    @from
    |> Enum.map(&get_rates_task/1)
    |> Enum.map(&Task.await/1)
    |> Enum.flat_map(fn
      {:ok, rates} -> rates
      :error -> []
    end)
    |> CryptoRates.Rates.save_rates()
  end

  defp get_rates_task(from) do
    fetcher = Application.get_env(:crypto_rates, :fetcher, CryptoCurrenciesFetcher)

    Task.async(fn -> fetcher.get_rates(from, @to) end)
  end
end
