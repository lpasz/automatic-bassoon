defmodule Vin.Repo.Migrations.CreateVehicle do
  use Ecto.Migration

  def change do
    create table(:vehicle) do
      add :vin, :string
      add :make, :string
      add :model, :string
      add :age, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
