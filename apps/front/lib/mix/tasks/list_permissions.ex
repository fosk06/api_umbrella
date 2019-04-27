defmodule Mix.Tasks.Permissions.List do
    use Mix.Task
    require Logger
    alias DbConnector.{Repo, Permission}
    import Ecto.Query, only: [where: 2, order_by: 2]

    @shortdoc "Display the permissions of the DB, can be filtered"
    def run(args) do
      Mix.Task.run "app.start"
      permissions = with [role | _ ] when is_binary(role) <- args ,
      true <-String.contains?(role, ["customer", "anonymous", "administrator"])
      do
        Permission|> where(role: ^role) |> Repo.all()
      else
        _ -> Permission |> order_by([asc: :role, asc: :operation_type]) |> Repo.all()
      end

      Enum.map(permissions, fn(p) -> 
        IO.puts "\"#{p.operation_name}\" #{p.operation_type} allowed for \"#{p.role}\" role " 
      end)
      # Logger.info "permissions: #{inspect(permissions)}"

    end
  end