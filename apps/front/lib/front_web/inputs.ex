defmodule FrontWeb.Schema.Inputs do
    use Absinthe.Schema.Notation
    
    input_object :sign_up do
        field :email, :string
        field :first_name, :string
        field :last_name, :string
        field :password, :string
    end
  
  end