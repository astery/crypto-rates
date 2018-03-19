defmodule CryptoRates.StubbedFetcher do
  @behaviour CryptoRates.Fetcher

  alias CryptoRates.Rate

  def get_rates(from, to_array, get_current_time \\ &DateTime.utc_now/0) do
    current_time = get_current_time.()

    rates =
      to_array
      |> Enum.map(fn to -> %Rate{
        from: from,
        to: to,
        rate: :rand.uniform(1000),
        at: current_time,
      } end)

    {:ok, rates}
  end
end
