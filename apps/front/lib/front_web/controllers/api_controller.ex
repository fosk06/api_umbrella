defmodule FrontWeb.ApiController do
  use FrontWeb, :controller

  def ping(conn, _params) do
    response = Greeter.ping()
    json(conn, response)
  end

end