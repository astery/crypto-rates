defmodule CryptoRates.Rates do
  use Ecto.Repo, otp_app: :crypto_rates
  import Ecto.Query, [only: [from: 2, where: 3]]

  alias CryptoRates.Rate

  @spec save_rates([Rate.t]) :: :ok
  def save_rates(rates) do
    rates_entries = rates |> Enum.map(&Map.from_struct/1)
    {_count, _} = insert_all("rates", rates_entries, on_conflict: :nothing)
    :ok
  end

  @spec get_single_rate_by_nearest_time(String.t, String.t, DateTime.t) :: nil | Rate.t
  def get_single_rate_by_nearest_time(from, to, at) do
    case get_left_and_right_rate(from, to, at) do
      {nil, nil} -> nil
      {nil, res} -> res
      {res, nil} -> res
      {res, res} -> res
      {first, second} ->
        if DateTime.diff(at, first.at) <= DateTime.diff(second.at, at) do
          first
        else
          second
        end
    end
  end

  defp rate_query(from, to) do
    from(
      r in "rates",
      where: r.from == ^from and r.to == ^to,
      order_by: r.at,
      limit: 1,
      select: %Rate{from: r.from, to: r.to, rate: r.rate, at: type(r.at, :utc_datetime)}
    )
  end

  defp get_left_rate(from, to, at) do
    rate_query(from, to)
    |> where([r], r.at <= ^at)
    |> one
  end

  defp get_right_rate(from, to, at) do
    rate_query(from, to)
    |> where([r], r.at >= ^at)
    |> one
  end

  # can be rewritten as union
  defp get_left_and_right_rate(from, to, at) do
    {get_left_rate(from, to, at), get_right_rate(from, to, at)}
  end
end
