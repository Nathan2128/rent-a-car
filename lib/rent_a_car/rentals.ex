defmodule RentACar.Rentals do
  @moduledoc """
  Rentals Context: interface for querying, booking, etc.
  """

  import Ecto.Query
  alias RentACar.Repo
  alias RentACar.Rentals.Booking
  alias RentACar.Rentals.Car
  alias RentACar.Rentals.Review
  alias RentACar.Accounts.User

  @doc """
  Fetches a car by its slug.
  ## Examples

      iex> get_car_by_slug!("tesla-cybertruck")
      %Car{...}

      iex> get_car_by_slug!("non-existent-slug")
      ** (Ecto.NoResultsError)
  """
  def get_car_by_slug!(slug) do
    Repo.get_by!(Car, slug: slug)
  end

  @doc """
  Returns a list of all cars.
  """
  def list_cars do
    Repo.all(Car)
  end

  @doc """
  Returns a list of cars matching the given criteria.

  Example Criteria:
  [{:limit, 15}, {:order, :asc}, {:filter, [{:matching, "tesla"}, {:electric, true}, {:passengers, 5}]}]
  """

  def list_cars(criteria) do
    query = from(p in Car)

    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:filter, filters}, query ->
        filter_with(filters, query)

      {:order, order}, query ->
        from(p in query, order_by: [{^order, :name}])
    end)
    |> Repo.all()
  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from(q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.description, ^pattern)
        )

      {:navigation, value}, query ->
        from(q in query, where: q.navigation == ^value)

      {:electric, value}, query ->
        from(q in query, where: q.electric == ^value)

      {:passengers, count}, query ->
        from(q in query, where: q.passengers >= ^count)

      {:available_between, %{start_date: start_date, end_date: end_date}}, query ->
        available_between(query, start_date, end_date)
    end)
  end

  defp available_between(query, start_date, end_date) do
    from(car in query,
      left_join: booking in Booking,
      on:
        booking.car == car.id and
          fragment(
            "(?, ?) OVERLAPS (?, ? + INTERVAL '1' DAY)",
            booking.start_date,
            booking.end_date,
            type(^start_date, :date),
            type(^end_date, :date)
          ),
      where: is_nil(booking.car)
    )
  end

  @doc """
  Returns the booking with the given `id`.

  Raises `Ecto.NoResultsError` if no booking was found.
  """
  def get_booking!(id) do
    Repo.get!(Booking, id)
  end

  @doc """
  Creates a booking for the given user.
  """
  def create_booking(%User{} = user, attrs) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Cancels the given booking.
  """
  def cancel_booking(%Booking{} = booking) do
    booking
    |> Booking.cancel_changeset(%{state: "cancelled"})
    |> Repo.update()
  end

  @doc """
  Creates a review for the given user.
  """
  def create_review(%User{} = user, attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end
