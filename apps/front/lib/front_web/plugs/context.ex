defmodule FrontWeb.Context do
    @behaviour Plug

    require Logger
    import Plug.Conn
    import Ecto.Query, only: [where: 2]
    alias DbConnector.{Repo, Person}
  
    def init(opts), do: opts

    def call(conn, _) do
      context = build_context(conn)
      Absinthe.Plug.put_options(conn, context: context)
    end

    # def call(conn, _) do
    #   case build_context(conn) do
    #     {:ok, context} ->
    #       put_private(conn, :absinthe, %{context: context})
    #     _ ->
    #       conn
    #   end
    # end
  
  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{jambon: "beurre"}
    end
  end
  
    defp authorize(token) do
      Person
      |> where(token: ^token)
      |> Repo.one()
      |> case do
          nil -> {:error, "Invalid authorization token"}
          user -> {:ok, current_user: user}
         end
    end
  end