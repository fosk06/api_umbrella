defmodule FrontWeb.Router do
  @moduledoc false
  
  use FrontWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
  pipeline :graphql do
	  plug FrontWeb.Context
  end

  scope "/api" do
    pipe_through [:api, :graphql]
    forward("/", Absinthe.Plug, schema: FrontWeb.Schema)
  end
end
