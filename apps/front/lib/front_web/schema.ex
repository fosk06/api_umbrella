defmodule FrontWeb.Schema do
    @moduledoc false
    use Absinthe.Schema
    import_types FrontWeb.Schema.Types
    import_types FrontWeb.Schema.Inputs


    query do
      @desc "Get all people"
      field :people, list_of(:person) do
        resolve &Person.Resolvers.getAllPeople/3
      end
  
      @desc "Get a person by email"
      field :person_by_email, :person do
        middleware FrontWeb.Middlewares.Authentication
        middleware FrontWeb.Middlewares.Permissions
        arg :email, non_null(:string)
        resolve &Person.Resolvers.findByEmail/2
      end

      @desc "Sign in"
      field :sign_in, :session do
        arg :input, non_null(:sign_in_input)
        resolve &Person.Resolvers.signIn/3
      end


    end

    mutation do
      @desc "Sign up"
      field :sign_up, type: :standard_reponse do
        arg :input, non_null(:sign_up_input)
        resolve &Person.Resolvers.signUp/3
      end
      
      @desc "Sign out"
      field :sign_out, type: :standard_reponse do
        arg(:id, non_null(:id))
        resolve &Person.Resolvers.signOut/2
       end
      
      @desc "Create"
      field :create_person, type: :person do
        arg :input, non_null(:sign_up_input)
        resolve &Person.Resolvers.create/2
      end
    
    end
  
  end