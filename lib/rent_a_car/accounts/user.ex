defmodule RentACar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :bookings, RentACar.Rentals.Booking
    has_many :reviews, RentACar.Rentals.Review

    timestamps()
  end

  def changeset(user, attrs) do
    required_fields = [:username, :first_name, :last_name, :email, :password]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_length(:username, min: 6)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset.valid? do
      true ->
        password = get_field(changeset, :password)
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
