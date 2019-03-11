defmodule FrontWeb.Schema do

    use Absinthe.Schema
    import_types FrontWeb.Schema.Types
    alias FrontWeb.Resolvers


    @desc "Get all items"
    query do
      field :items, list_of(:item) do
        resolve &Resolvers.Item.getItems/3
      end
      field :item, :item do
        arg :id, non_null(:id)
        resolve &Resolvers.Item.getItemById/3
      end
    end
  
  end