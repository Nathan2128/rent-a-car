defmodule RentACar.Rentals.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "bookings" do
    field :start_date, :date
    field :end_date, :date
    field :state, :string, default: "reserved"
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
    |> validate_start_date_before_end_date()
    |> validate_dates_available()
    |> assoc_constraint(:car)
    |> assoc_constraint(:user)
    |> calculate_total_price()
  end

  def cancel_changeset(booking, attrs) do
    booking
    |> cast(attrs, [:state])
    |> validate_required([:state])
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

  defp validate_start_date_before_end_date(changeset) do
    case changeset.valid? do
      true ->
        start_date = get_field(changeset, :start_date)
        end_date = get_field(changeset, :end_date)

        case Date.compare(start_date, end_date) do
          :gt ->
            add_error(changeset, :start_date, "selection is after :end_date")

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  defp validate_dates_available(changeset) do
    case changeset.valid? do
      true ->
        start_date = get_field(changeset, :start_date)
        end_date = get_field(changeset, :end_date)
        car_id = get_field(changeset, :car_id)

        case dates_available?(start_date, end_date, car_id) do
          true ->
            changeset

          false ->
            add_error(changeset, :start_date, "is not available")
        end

      _ ->
        changeset
    end
  end

  defp dates_available?(start_date, end_date, car_id) do
    query =
      from booking in RentACar.Rentals.Booking,
        where:
          booking.car_id == ^car_id and
            fragment(
              "(?, ?) OVERLAPS (?, ? + INTERVAL '1' DAY)",
              booking.start_date,
              booking.end_date,
              type(^start_date, :date),
              type(^end_date, :date)
            )

    case RentACar.Repo.all(query) do
      [] -> true
      _ -> false
    end
  end
end
