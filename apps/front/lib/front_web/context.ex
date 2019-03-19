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
  
    @doc """
    Return the current user context based on the authorization header
    """
    def build_context(conn) do
      Logger.info "build context"
      with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_person} <- authorize(token) do
        %{current_person: current_person}
      else
        _ -> %{}
      end
    end
  
    defp authorize(token) do
      Logger.info "authorize with #{inspect(token)}"
      Person
      |> where(token: ^token)
      |> Repo.one
      |> case do
        nil -> {:error, "invalid authorization token"}
        person -> {:ok, person}
      end
    end
  
  end