defmodule VinWeb.VehicleLive.FormComponent do
  use VinWeb, :live_component

  alias Vin.Vehicles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage vehicle records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="vehicle-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:vin]} type="text" label="Vin" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Vehicle</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{vehicle: vehicle} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Vehicles.change_vehicle(vehicle))
     end)}
  end

  @impl true
  def handle_event("validate", %{"vehicle" => vehicle_params}, socket) do
    changeset = Vehicles.change_vehicle(socket.assigns.vehicle, vehicle_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"vehicle" => vehicle_params}, socket) do
    save_vehicle(socket, socket.assigns.action, vehicle_params)
  end

  defp save_vehicle(socket, :edit, params) do
    case Vehicles.update_vehicle(socket.assigns.vehicle, params) do
      {:ok, vehicle} ->
        notify_parent({:saved, vehicle})

        {:noreply,
         socket
         |> put_flash(:info, "Vehicle updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_vehicle(socket, :new, %{"vin" => vin}) do
    date = Date.utc_today()

    with {:ok, %{"Results" => [%{"Make" => make, "Model" => model, "ModelYear" => model_year}]}} <-
           Vehicles.get_by_vin(vin),
         age <- date.year - String.to_integer(model_year),
         {:ok, vehicle} <-
           Vehicles.create_vehicle(%{
             "vin" => vin,
             "make" => make,
             "model" => model,
             "age" => age
           }) do
      notify_parent({:saved, vehicle})

      {:noreply,
       socket
       |> put_flash(:info, "Vehicle created successfully")
       |> push_patch(to: socket.assigns.patch)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
