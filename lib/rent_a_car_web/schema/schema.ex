defmodule RentACarWeb.Schema.Schema do
  use Absinthe.Schema

  import_types(RentACarWeb.Schema.Types)

  alias RentACar.Accounts
  alias RentACar.Rentals
  alias RentACarWeb.Resolvers

  query do
    @desc "Get a car by slug"
    field :car, :car do
      arg(:slug, non_null(:string))
      resolve(&Resolvers.Rentals.car/3)
    end

    @desc "Get a list of cars"
    field :cars, list_of(:car) do
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :car_filter)
      arg(:offset, :integer)
      resolve(&Resolvers.Rentals.cars/3)
    end
  end

  mutation do
    @desc "Create a booking for a car"
    field :create_booking, :booking do
      arg :car_id, non_null(:id)
      arg :start_date, non_null(:date)
      arg :end_date, non_null(:date)
      resolve(&Resolvers.Rentals.create_booking/3)
    end
  end

  # Input Object Types
  @desc "Filters for the list of cars"
  input_object :car_filter do
    @desc "Matching a name or description"
    field(:matching, :string)

    @desc "Navigation included"
    field(:navigation, :boolean)

    @desc "Electric vehicle"
    field(:electric, :boolean)

    @desc "Passenger capacity"
    field(:passengers, :integer)

    @desc "Available between a start and end date"
    field(:available_between, :date_range)
  end

  @desc "Start and end dates"
  input_object :date_range do
    field(:start_date, non_null(:date))
    field(:end_date, non_null(:date))
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  # call back functions for absinthe
  def context(ctx) do
    # source = Dataloader.Ecto.new(RentACar.Repo)
    ctx = Map.put(ctx, :current_user, RentACar.Accounts.get_user(1))
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Rentals, Rentals.datasource())
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
