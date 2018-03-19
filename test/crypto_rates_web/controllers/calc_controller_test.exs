defmodule CryptoRatesWeb.CalcControllerTest do
  use CryptoRatesWeb.ConnCase

  # GET /api/calc
  @url "/api/calc"
  @at "2015-01-23T23:50:07Z"
  @at_datetime DateTime.from_iso8601(@at)
  @successful_resp %{amount: 10, at: @at}

  setup %{conn: conn} do
    conn =
      conn
      |> put_private(:crypto_rates_current_time_fn, fn ->
        @at_datetime
      end)
      |> put_private(:crypto_rates_calc_rate, fn
        "BTC", "USD", 1, @at_datetime -> @successful_resp
      end)
    %{conn: conn}
  end

  describe "requested with good full params" do
    test "should return successful response", %{conn: conn} do
      conn = get conn, @url, good_full_params()
      assert json_response(conn, 200) == @successful_resp
    end
  end

  describe "requested with good params without date" do
    test "should return successful response", %{conn: conn} do
      conn = get conn, @url, good_params_without_date()
      assert json_response(conn, 200) == @successful_resp
    end
  end

  describe "requested with bad params" do
    test "should return error", %{conn: conn} do
      conn = get conn, @url, bad_params()
      assert json_response(conn, 401) == %{error: "something happen"}
    end
  end

  defp good_full_params(), do: %{from: "BTC", amount: 1, at: "2015-01-23T23:50:07Z"}
  defp good_params_without_date(), do: %{from: "BTC"}
  defp bad_params(), do: %{from: "DDD", at: "not a date"}
end
