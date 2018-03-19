defmodule CryptoRatesWeb.CalcController do
  use CryptoRatesWeb, :controller
  import Ecto.Changeset

  @to "USD"

  def calc(%{private: %{
    crypto_rates_current_time_fn: time_fn,
    crypto_rates_calc_rate: calc_rate,
  }} = conn, params) do
    {%{at: time_fn.()}, %{from: :string, amount: :float, at: :utc_datetime}}
    |> cast(params, [:from, :amount, :at])
    |> validate_required([:from, :amount])
    |> validate_inclusion(:from, CryptoRates.from_currencies)
    |> case do
      %{errors: []} = cs ->
        %{from: from, amount: amount, at: at} = apply_changes(cs)
        case calc_rate.(from, @to, amount, at) do
          {:ok, res} -> json conn, res
          {:error, _} -> json_error conn, %{error: "something happen"}
        end
      %{errors: _} ->
        json_error conn, %{error: "something happen"}
    end
  end

  defp json_error(conn, error) do
    conn
    |> put_status(401)
    |> json(error)
  end
end
