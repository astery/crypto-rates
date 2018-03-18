defmodule CryptoCurrenciesFetcher do
  alias CryptoRates.Rate
  require Logger

  @spec get_rates(String.t, [String.t], (() -> DateTime.t)) :: {:ok, [Rate.t]} | :error
  def get_rates(from, to, get_current_time \\ &DateTime.utc_now/0) do
    try do
      {:ok, result} =
        url_for(from, to)
        |> String.to_charlist
        |> :httpc.request
      {{_, 200, _}, _headers, body} = result
      # real time somewhere between request start and it's end
      current_time = get_current_time.()

      body
      |> Poison.decode!
      |> to_rates(from, to, current_time)
      |> wrap_ok_tuple
    rescue
      e ->
        Logger.debug(inspect e)
        :error
    end
  end

  defp url_for(from, to) do
    "https://min-api.cryptocompare.com/data/price?fsym=#{from}&tsyms=#{Enum.join(to, ",")}"
  end

  defp to_rates(rates_data, from, to_array, current_time) do
    Enum.map(to_array, fn to ->
      %Rate{from: from, to: to, rate: rates_data[to], at: current_time}
    end)
  end

  defp wrap_ok_tuple(res), do: {:ok, res}
end
