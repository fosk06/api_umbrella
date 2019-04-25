defmodule FrontWeb.Middlewares.Permissions do
    require Logger

    @behaviour Absinthe.Middleware
    def call(resolution, config) do
      name = resolution.definition.schema_node.name
      permissions = resolution.context.permissions

      case check_is_authorized(permissions, name) do
        true -> resolution.errors
        false -> resolution.errors ++ ["not authorized"]
      end
      |> case do
        errors when length(errors) > 0 -> 
          resolution |> Absinthe.Resolution.put_result({:error, Enum.join(errors, ",")})
        errors -> resolution   
       end
 
    end
  
    defp check_is_authorized(permissions, name) do

      case is_nil(permissions) do
        true -> false
        false -> 
          found = Enum.find_value(permissions, fn p -> p.value == name end)
          case found do
            nil -> false
            _ -> true
          end
      end
    end
  
  end