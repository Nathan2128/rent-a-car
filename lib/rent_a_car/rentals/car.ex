defmodule RentACar.Rentals.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :price_per_day, :decimal
    field :image, :string
    field :image_thumbnail, :string
    field :passengers, :integer
    field :navigation, :boolean, default: false
    field :electric, :boolean, default: false

    has_many :bookings, RentACar.Rentals.Booking
    has_many :reviews, RentACar.Rentals.Review

    timestamps()
  end

  def changeset(car, attrs) do
    required_fields = [
      :name,
      :slug,
      :description,
      :price_per_day,
      :image,
      :image_thumbnail,
      :passengers
    ]

    optional_fields = [:navigation, :electric]

    car
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end
end
