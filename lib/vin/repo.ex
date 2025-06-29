defmodule Vin.Repo do
  use Ecto.Repo,
    otp_app: :vin,
    adapter: Ecto.Adapters.Postgres
end
