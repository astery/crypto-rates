defmodule CryptoRatesWeb.ErrorView do
  use CryptoRatesWeb, :view

  def render("404.json", _assigns), do: %{error: "Not found"}
  def render("500.json", _assigns), do: %{error: "Server internal error"}

  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
