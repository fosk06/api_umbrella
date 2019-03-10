defmodule FrontWeb.Schema do

    use Absinthe.Schema
    import_types FrontWeb.Schema.Types
    alias FrontWeb.Resolvers

    # Example data
    @items %{
      "foo" => %{id: "foo", name: "Foo"},
      "bar" => %{id: "bar", name: "Bar"}
    }
    @desc "Get all items"
    query do
      field :items, list_of(:item) do
        resolve &Resolvers.Item.getItems/3
      end
    end
  
  end