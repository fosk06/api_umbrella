defmodule FrontWeb.PageController do
  use FrontWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end