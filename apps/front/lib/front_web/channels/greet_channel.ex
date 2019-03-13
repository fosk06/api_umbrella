defmodule FrontWeb.GreetChannel do
  use Phoenix.Channel

  def join("room:greet", _message, socket) do
    {:ok, socket}
  end

  def greet("room:greet", name, socket) do
    greet = %{status: "up"}
    {:ok, greet}
  end

  def handle_in("greet", %{"name" => name}, socket) do
    greet = %{status: "up"}
    broadcast! socket, "greet", %{msg: "up"}
    {:noreply, socket}
  end
end