defmodule FrontWeb.Schema.Inputs do
    @moduledoc false
    
    use Absinthe.Schema.Notation
    
    @desc "the sign up input"
    input_object :sign_up_input do
      field :email, non_null(:string)
      field :first_name, non_null(:string)
      field :last_name, non_null(:string)
      field :password, non_null(:string)
    end
    
    @desc "the sign up input"
    input_object :sign_in_input do
      field :email, non_null(:string)
      field :password, non_null(:string)
    end
  
  end