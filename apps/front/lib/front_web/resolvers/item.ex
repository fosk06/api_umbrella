defmodule FrontWeb.Resolvers.Item do
    # Example data
    @items [%{id: "foo", name: "Foo"}, %{id: "bar", name: "Bar"}]

    def getItems(_parent, _args, _resolution) do
        {:ok, @items}
    end

    def getItemById(_parent, _args, _resolution) do
        {:ok, @items}
    end
  
  end