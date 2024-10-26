defmodule RentACarWeb.Resolvers.Rentals do
  alias RentACar.Rentals

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
         message: "Could not create booking",
         details: ChangesetErrors.error_details(changeset)
        }

      {:ok, booking} ->
        {:ok, booking}
    end
  end
end
