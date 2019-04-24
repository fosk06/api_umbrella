defmodule FrontWeb.Middlewares.Authentication do
    require Logger

    @behaviour Absinthe.Middleware
    def call(resolution, config) do
      case resolution.context do
        %{current_person: person} ->
          resolution
        _ ->
          resolution
          |> Absinthe.Resolution.put_result({:error, "not authenticated"})
      end
    end
  
  end