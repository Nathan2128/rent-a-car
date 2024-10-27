defmodule RentACarWeb.Schema.Types do
  use Absinthe.Schema.Notation
  alias RentACar.Accounts
  alias RentACar.Rentals


  import_types(Absinthe.Type.Custom)

  object :car do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:slug, non_null(:string))
    field(:description, non_null(:string))
    field(:passengers, non_null(:integer))
    field(:electric, non_null(:boolean))
    field(:navigation, non_null(:boolean))
    field(:price_per_day, non_null(:decimal))
    field(:image, non_null(:string))
    field(:image_thumbnail, non_null(:string))
    field :bookings, list_of(:booking), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals, :bookings, args: %{scope: :car})
    field :reviews, list_of(:review), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals)
  end

  object :booking do
    field(:id, non_null(:id))
    field(:start_date, non_null(:date))
    field(:end_date, non_null(:date))
    field(:state, non_null(:string))
    field(:total_price, non_null(:decimal))
    field(:user, non_null(:user), resolve: Absinthe.Resolution.Helpers.dataloader(Accounts))
    field(:car, non_null(:car), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals))
  end

  object :review do
    field(:id, non_null(:id))
    field(:rating, non_null(:integer))
    field(:comment, non_null(:string))
    field(:inserted_at, non_null(:naive_datetime))
    field(:user, non_null(:user), resolve: Absinthe.Resolution.Helpers.dataloader(Accounts))
    field(:car, non_null(:car), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals))
  end

  object :user do
    field(:username, non_null(:string))
    field(:email, non_null(:string))
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))

    field(:bookings, list_of(:booking), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals))
    field(:reviews, list_of(:review), resolve: Absinthe.Resolution.Helpers.dataloader(Rentals))
  end

  object :session do
    field(:user, non_null(:user))
    field(:token, non_null(:string))
  end
end
