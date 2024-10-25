defmodule RentACar.Rentals.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_date, :date
    field :end_date, :date
    field :state, :string, default: "available"
    field :total_price, :decimal

    belongs_to :car, RentACar.Rentals.Car
    belongs_to :user, RentACar.Accounts.User

    timestamps()
  end

  def changeset(booking, attrs) do
    required_fields = [:start_date, :end_date, :car_id]
    optional_fields = [:state]

    booking
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> assoc_constraint(:car)
    |> assoc_constraint(:user)
    |> calculate_total_price()
  end

  defp calculate_total_price(changeset) do
    case changeset.valid? do
      true ->
        car_id = get_field(changeset, :car_id)
        end_date = get_field(changeset, :end_date)
        start_date = get_field(changeset, :start_date)

        car = RentACar.Repo.get!(RentACar.Rentals.Car, car_id)

        days = Date.diff(end_date, start_date)
        total_price = Decimal.mult(car.price_per_day, days)

        put_change(changeset, :total_price, total_price)

      _ ->
        changeset
    end
  end
end
