defmodule FrontWeb.Schema.Inputs do
    use Absinthe.Schema.Notation
    
    @desc "the sign up input"
    input_object :sign_up_input do
      field :email, :string
      field :first_name, :string
      field :last_name, :string
      field :password, :string
    end
  
  end