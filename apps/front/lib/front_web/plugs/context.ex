defmodule FrontWeb.Context do
    @behaviour Plug

    require Logger
    import Plug.Conn
    import Ecto.Query, only: [where: 2]
    alias DbConnector.{Repo, Person, Permission}
  
    def init(opts), do: opts

    def call(conn, _) do
      context = build_context(conn)
      Absinthe.Plug.put_options(conn, context: context)
    end
  
  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, current_person} <- authorize(token) do
      person = current_person[:current_person]
      perms = get_permissions(person.role)
      %{current_person: person, token: token, permissions: perms, role: person.role}
    else
      _ -> 
        perms = get_permissions("anonymous")
        %{role: "anonymous", permissions: perms}
    end
  end
  
    defp get_permissions(role) do
      Permission
      |> where(role: ^role)
      |> Repo.all()
    end

    defp authorize(token) do
      Person
      |> where(token: ^token)
      |> Repo.one()
      |> case do
          nil -> {:error, "Invalid authorization token"}
          user -> {:ok, current_person: user}
         end
    end
  end