defmodule RentACarWeb.Resolvers.Rentals do
  alias RentACar.Rentals

  def car(_, %{slug: slug}, _) do
    {:ok, Rentals.get_car_by_slug!(slug)}
  end

  def cars(_, args, _) do
    {:ok, Rentals.list_cars(args)}
  end
end
