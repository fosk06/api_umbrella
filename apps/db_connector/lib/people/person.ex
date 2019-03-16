defmodule DbConnector.Person do
    require Logger
    use Ecto.Schema
    import Ecto.Changeset

    schema "people" do
      field :first_name, :string
      field :last_name, :string
      field :email, :string
      field :email_token, :string
      field :password, :string, virtual: true
      field :password_hash, :string
      field :email_validated, :boolean
      field :age, :integer
      
      timestamps(type: :utc_datetime_usec)
    end

    def changeset(person, params \\ %{}) do
        person
        |> cast(params, [:first_name,:last_name, :email,:email_token, :email_validated, :password, :age])
        |> validate_required([:first_name, :last_name, :password, :email])
        |> validate_format(:email, ~r/@/)
        |> validate_inclusion(:age, 0..130)
        |> validate_length(:first_name, min: 3, max: 20)
        |> validate_length(:last_name, min: 3, max: 20)
        |> validate_length(:password, min: 5, max: 20)
        |> unique_constraint(:email, downcase: true)
    end


end