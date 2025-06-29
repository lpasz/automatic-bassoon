defmodule Vin.VehiclesTest do
  use Vin.DataCase

  alias Vin.Vehicles

  describe "vehicle" do
    alias Vin.Vehicles.Vehicle

    import Vin.VehiclesFixtures

    @invalid_attrs %{vin: nil, make: nil, model: nil, age: nil}

    test "list_vehicle/0 returns all vehicle" do
      vehicle = vehicle_fixture()
      assert Vehicles.list_vehicle() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Vehicles.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = %{vin: "some vin", make: "some make", model: "some model", age: 42}

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.create_vehicle(valid_attrs)
      assert vehicle.vin == "some vin"
      assert vehicle.make == "some make"
      assert vehicle.model == "some model"
      assert vehicle.age == 42
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      update_attrs = %{vin: "some updated vin", make: "some updated make", model: "some updated model", age: 43}

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.update_vehicle(vehicle, update_attrs)
      assert vehicle.vin == "some updated vin"
      assert vehicle.make == "some updated make"
      assert vehicle.model == "some updated model"
      assert vehicle.age == 43
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Vehicles.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Vehicles.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_vehicle(vehicle)
    end
  end
end
