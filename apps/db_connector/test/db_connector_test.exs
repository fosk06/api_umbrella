defmodule DbConnectorTest do
  @moduledoc false
  
  use ExUnit.Case
  doctest DbConnector

  test "greets the world" do
    assert DbConnector.hello() == :world
  end
end
