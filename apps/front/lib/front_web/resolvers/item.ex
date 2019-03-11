defmodule FrontWeb.Resolvers.Item do
    require Logger
    
    # Example data
    @items [%{id: "foo", name: "Foo"}, %{id: "bar", name: "Bar"}]

    def getItems(_parent, _args, _resolution) do
        {:ok, @items}
    end

    def getItemById(_parent, %{id: item_id}, _resolution) do
        Logger.info "item_id: #{inspect(item_id)}"
        item = Enum.find(@items, fn item -> item[:id] == item_id end)
        {:ok, item}
    end
  
  end