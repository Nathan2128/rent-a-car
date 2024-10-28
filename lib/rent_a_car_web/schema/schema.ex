defmodule RentACarWeb.Schema.Schema do
  use Absinthe.Schema

  import_types(RentACarWeb.Schema.Types)

  alias RentACar.Accounts
  alias RentACar.Rentals
  alias RentACarWeb.Resolvers
  alias RentACarWeb.Schema.Middleware.Authenticate

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
      arg(:car_id, non_null(:id))
      arg(:start_date, non_null(:date))
      arg(:end_date, non_null(:date))
      middleware Authenticate
      resolve(&Resolvers.Rentals.create_booking/3)
    end

    @desc "Cancel a booking for a car"
    field :cancel_booking, :booking do
      arg(:booking_id, non_null(:id))
      middleware Authenticate
      resolve(&Resolvers.Rentals.cancel_booking/3)
    end

    @desc "Create a review for a car"
    field :create_review, :review do
      arg(:car_id, non_null(:id))
      arg(:comment, :string)
      arg(:rating, non_null(:integer))
      middleware Authenticate
      resolve(&Resolvers.Rentals.create_review/3)
    end

    @desc "Create an account"
    field :sign_up, :session do
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))
      resolve(&Resolvers.Accounts.sign_up/3)
    end

    @desc "Sign in a user"
    field :sign_in, :session do
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.sign_in/3)
    end
  end

  subscription do
    @desc "Subscribe to booking changes for a specific car"
    field :booking_change, :booking do
      arg(:car_id, non_null(:id))

      config(fn args, _res ->
        {:ok, topic: args.car_id}
      end)
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
    IO.inspect(ctx)

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
