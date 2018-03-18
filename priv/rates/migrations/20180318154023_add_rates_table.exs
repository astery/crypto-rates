defmodule CryptoRates.Rates.Migrations.AddRatesTable do
  use Ecto.Migration

  def change do
    create table(:rates, primary_key: false) do
      add :from, :string, primary_key: true
      add :to, :string, primary_key: true
      add :rate, :float, default: 0.0
      add :at, :utc_datetime, primary_key: true
    end
  end
end
