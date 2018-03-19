defmodule CryptoRatesWeb.Router do
  use CryptoRatesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CryptoRatesWeb do
    pipe_through :api

    get "/calc", CalcController, :calc
  end
end
