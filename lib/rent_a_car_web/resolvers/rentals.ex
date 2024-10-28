defmodule RentACarWeb.Resolvers.Rentals do
  alias RentACar.Rentals
  alias RentACarWeb.Schema.ChangesetErrors

  def car(_, %{slug: slug}, _) do
    {:ok, Rentals.get_car_by_slug!(slug)}
  end

  def cars(_, args, _) do
    {:ok, Rentals.list_cars(args)}
  end

  def create_booking(_, args, %{context: %{current_user: user}}) do
    case Rentals.create_booking(user, args) do
      {:error, changeset} ->
        {:error,
         message: "Booking unsuccessful.", details: ChangesetErrors.error_details(changeset)}

      {:ok, booking} ->
        publish_booking_change(booking)
        {:ok, booking}
    end
  end

  def cancel_booking(_, args, %{context: %{current_user: user}}) do
    booking = Rentals.get_booking!(args[:booking_id])

    if booking.user_id == user.id do
      case Rentals.cancel_booking(booking) do
        {:error, changeset} ->
          {
            :error,
            message: "Cancellation unsuccessful.",
            details: ChangesetErrors.error_details(changeset)
          }

        {:ok, booking} ->
          publish_booking_change(booking)
          {:ok, booking}
      end
    else
      {
        :error,
        message: "Booking must be under current user."
      }
    end
  end

  def create_review(_, args, %{context: %{current_user: user}}) do
    case Rentals.create_review(user, args) do
      {:error, changeset} ->
        {
          :error,
          message: "Review creation unsuccessful.", details: ChangesetErrors.error_details(changeset)
        }

      {:ok, review} ->
        {:ok, review}
    end
  end

  defp publish_booking_change(booking) do
    Absinthe.Subscription.publish(
      RentACarWeb.Endpoint,
      booking,
      booking_change: booking.car_id
    )
  end
end
