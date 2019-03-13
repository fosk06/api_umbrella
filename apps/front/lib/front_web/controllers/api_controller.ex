defmodule FrontWeb.ApiController do
  use FrontWeb, :controller

  def ping(conn, _params) do
    response = %{status: "up"}
    json(conn, response)
  end

end