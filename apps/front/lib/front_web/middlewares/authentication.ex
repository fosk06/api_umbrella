defmodule FrontWeb.Middlewares.Authentication do
    @moduledoc false
    
    require Logger

    @behaviour Absinthe.Middleware
    def call(resolution, config) do
      # Logger.info "errors: #{inspect(resolution.errors)}"
      case resolution.context do
        %{current_person: person} ->
          resolution.errors
        _ -> resolution.errors ++ ["not authenticated"]
      end
      |> case do
        errors when length(errors) > 0 -> 
          resolution |> Absinthe.Resolution.put_result({:error, Enum.join(errors, ",")})
        errors -> resolution   
       end
    end
  
  end