defmodule PersonTest do
  use ExUnit.Case
  doctest Person

  test "greets the world" do
    assert Person.hello() == :world
  end
end
