defmodule FrontWeb.Schema do

    use Absinthe.Schema
    import_types FrontWeb.Schema.Types
    alias FrontWeb.Resolvers


    query do
      @desc "Get all items"
      field :items, list_of(:item) do
        resolve &Resolvers.Item.getItems/3
      end
      @desc "Get one item"
      field :item, :item do
        arg :id, non_null(:id)
        resolve &Resolvers.Item.getItemById/3
      end
      @desc "Get all people"
      field :people, list_of(:person) do
        resolve &Person.getAllPeople/3
      end
    end

    mutation do
      @desc "Sign up"
      field :sign_up, type: :standard_reponse do
        arg :input, non_null(:sign_up_input)
        resolve &Person.signUp/3
      end
    
    end
  
  end