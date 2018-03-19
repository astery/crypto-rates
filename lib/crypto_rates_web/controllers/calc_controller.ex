defmodule CryptoRatesWeb.CalcController do
  use CryptoRatesWeb, :controller

  def calc(conn, _params) do
    json conn, %{}
  end
end
