# This plug adds an Absinthe execution context to the Phoenix connection.
# If the request header contains a valid auth token, the corresponding
# user is added to the context, making it accessible to all resolvers.
# If the token is invalid or absent, the context remains empty.
#
# This plug should be executed before `Absinthe.Plug` in the `:api` router
# to ensure the context is properly set up for `Absinthe.Plug` to use.

defmodule RentACarWeb.Plugs.SetCurrentUser do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{id: id}} <- RentACarWeb.AuthToken.verify(token),
         %{} = user <- RentACar.Accounts.get_user(id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
