defmodule RentACar.Accounts do
  @moduledoc """
  The Accounts context: interface for account creation, authentication, querying, etc.
  """

  import Ecto.Query, warn: false
  alias RentACar.Repo
  alias RentACar.Accounts.User

  @doc """
  Returns the user with the given `id`.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticates a user.
  """
  def authenticate(username, password) do
    user = Repo.get_by(User, username: username)

    with %{password_hash: password_hash} <- user,
         true <- Bcrypt.verify_pass(password, password_hash) do
      {:ok, user}
    else
      _ -> {:error, "could not authenticate"}
    end
  end

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
