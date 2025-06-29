defmodule Vin.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle" do
    field :vin, :string
    field :make, :string
    field :model, :string
    field :age, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:vin, :make, :model, :age])
    |> validate_required([:vin, :make, :model, :age])
  end
end
