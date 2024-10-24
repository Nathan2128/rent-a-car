defmodule RentACar.Repo do
  use Ecto.Repo,
    otp_app: :rent_a_car,
    adapter: Ecto.Adapters.Postgres
end
