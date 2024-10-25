defmodule RentACar.Rentals.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :rating, :integer
    field :comment, :string

    belongs_to :car, RentACar.Rentals.Car
    belongs_to :user, RentACar.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(review, attrs) do
    required_fields = [:rating, :comment, :car_id]

    review
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> assoc_constraint(:car)
    |> assoc_constraint(:user)
  end
end
