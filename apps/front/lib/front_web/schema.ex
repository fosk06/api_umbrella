defmodule FrontWeb.Schema do

    use Absinthe.Schema
    import_types FrontWeb.Schema.Types
    import_types FrontWeb.Schema.Inputs


    query do
      @desc "Get all people"
      field :people, list_of(:person) do
        resolve &Person.Resolvers.getAllPeople/3
      end
    end

    mutation do
      @desc "Sign up"
      field :sign_up, type: :standard_reponse do
        arg :input, non_null(:sign_up_input)
        resolve &Person.Resolvers.signUp/3
      end
    
    end
  
  end