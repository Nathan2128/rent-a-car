defmodule RentACarWeb.AuthToken do
  @doc """
  Generates a token by encoding and signing the given `user` id,
  which clients can use for API authentication.
  """
  def sign(user) do
    Phoenix.Token.sign(RentACarWeb.Endpoint, token_salt(), %{id: user.id})
  end

  @doc """
  Extracts and validates the original data from the provided `token`,
  ensuring its authenticity and integrity.
  """
  def verify(token) do
    Phoenix.Token.verify(RentACarWeb.Endpoint, token_salt(), token, max_age: 365 * 24 * 3600)
  end

  defp token_salt do
    Application.get_env(:rent_a_car, __MODULE__)[:token_salt] |> IO.inspect()
  end
end
