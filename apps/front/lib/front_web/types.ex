defmodule FrontWeb.Schema.Types do
    use Absinthe.Schema.Notation
    
    @desc "An item"
    object :item do
      field :id, :id
      field :name, :string
    end

    @desc "An Person"
    object :person do
      field :id, :id
      field :first_name, :string
      field :last_name, :string
      field :email, :string
      field :email_token, :string
      field :password, :string
      field :email_validated, :boolean
      field :age, :integer
    end
  
  end