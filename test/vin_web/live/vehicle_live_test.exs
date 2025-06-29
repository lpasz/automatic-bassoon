defmodule VinWeb.VehicleLiveTest do
  use VinWeb.ConnCase

  import Phoenix.LiveViewTest
  import Vin.VehiclesFixtures

  @create_attrs %{vin: "some vin", make: "some make", model: "some model", age: 42}
  @update_attrs %{vin: "some updated vin", make: "some updated make", model: "some updated model", age: 43}
  @invalid_attrs %{vin: nil, make: nil, model: nil, age: nil}

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end

  describe "Index" do
    setup [:create_vehicle]

    test "lists all vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, ~p"/vehicle")

      assert html =~ "Listing Vehicle"
      assert html =~ vehicle.vin
    end

    test "saves new vehicle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle")

      assert index_live |> element("a", "New Vehicle") |> render_click() =~
               "New Vehicle"

      assert_patch(index_live, ~p"/vehicle/new")

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicle")

      html = render(index_live)
      assert html =~ "Vehicle created successfully"
      assert html =~ "some vin"
    end

    test "updates vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle")

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(index_live, ~p"/vehicle/#{vehicle}/edit")

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicle")

      html = render(index_live)
      assert html =~ "Vehicle updated successfully"
      assert html =~ "some updated vin"
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle")

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicle-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, ~p"/vehicle/#{vehicle}")

      assert html =~ "Show Vehicle"
      assert html =~ vehicle.vin
    end

    test "updates vehicle within modal", %{conn: conn, vehicle: vehicle} do
      {:ok, show_live, _html} = live(conn, ~p"/vehicle/#{vehicle}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(show_live, ~p"/vehicle/#{vehicle}/show/edit")

      assert show_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#vehicle-form", vehicle: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/vehicle/#{vehicle}")

      html = render(show_live)
      assert html =~ "Vehicle updated successfully"
      assert html =~ "some updated vin"
    end
  end
end
