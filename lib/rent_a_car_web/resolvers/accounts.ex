defmodule RentACarWeb.Resolvers.Accounts do
  alias RentACar.Accounts
  alias RentACarWeb.Schema.ChangesetErrors
  alias RentACarWeb.AuthToken

  def sign_up(_, args, _) do
    case Accounts.create_user(args) do
      {:error, changeset} ->
        {
          :error,
          message: "Account creation unsuccessful.",
          details: ChangesetErrors.error_details(changeset)
        }

      {:ok, user} ->
        token = AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end

  def sign_in(_, %{username: username, password: password}, _) do
    case Accounts.authenticate(username, password) do
      {:error, error_msg} ->
        {:error, error_msg}

      {:ok, user} ->
        token = AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end
end
