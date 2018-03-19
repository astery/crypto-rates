defmodule CryptoRates.Rates do
  use Ecto.Repo, otp_app: :crypto_rates
  import Ecto.Query, [only: [from: 2, where: 3, order_by: 2, group_by: 3]]

  alias CryptoRates.Rate

  @spec save_rates([Rate.t]) :: :ok
  def save_rates(rates) do
    rates_entries = rates |> Enum.map(&Map.from_struct/1)
    {_count, _} = insert_all("rates", rates_entries, on_conflict: :nothing)
    CryptoRates.PubSub.notify(rates)
    :ok
  end

  @spec all_rates_by_nearest_time(DateTime.t) :: nil | Rate.t
  def all_rates_by_nearest_time(at) do
    from(
      r in "rates",
      select: %Rate{from: r.from, to: r.to, rate: r.rate, at: type(r.at, :utc_datetime)}
    )
    |> where([r], r.at >= ^at)
    |> order_by(asc: :at)
    |> group_by([r], r.from and r.to)
    |> all
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
      limit: 1,
      select: %Rate{from: r.from, to: r.to, rate: r.rate, at: type(r.at, :utc_datetime)}
    )
  end

  defp get_left_rate(from, to, at) do
    rate_query(from, to)
    |> where([r], r.at <= ^at)
    |> order_by(desc: :at)
    |> one
  end

  defp get_right_rate(from, to, at) do
    rate_query(from, to)
    |> where([r], r.at >= ^at)
    |> order_by(asc: :at)
    |> one
  end

  # can be rewritten as union
  defp get_left_and_right_rate(from, to, at) do
    {get_left_rate(from, to, at), get_right_rate(from, to, at)}
  end

  @spec convert(String.t, String.t, float, DateTime.t) :: {:error, any} | {:ok, %{from_amount: float, to_amount: float}}
  def convert(from, to, amount, at) do
    get_single_rate_by_nearest_time(from, to, at)
    |> case do
      nil -> {:error, "not_found"}
      %{rate: rate} = res ->
        {:ok, res |> Map.from_struct |> Map.merge(%{
          from_amount: amount,
          to_amount: amount * rate,
        })}
    end
  end
end
