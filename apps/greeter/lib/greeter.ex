defmodule Greeter do
  @moduledoc """
  Documentation for Greeter.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Greeter.hello()
      :world

  """
  def hello(name), do: "Hello #{name}"
  
  def ping() do
    %{message: "pong"}
  end
end
