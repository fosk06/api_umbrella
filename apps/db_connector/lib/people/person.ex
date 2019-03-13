defmodule DbConnector.Person do
    require Logger
    use Ecto.Schema
    import Ecto.Changeset

    schema "people" do
      field :first_name, :string
      field :last_name, :string
      field :email, :string
      field :email_token, :string
      field :password, :string
      field :email_validated, :boolean
      field :age, :integer
    end

    def changeset(person, params \\ %{}) do
        person
        |> cast(params, [:first_name,:last_name, :email, :email_validated, :password, :age])
        |> validate_required([:first_name, :last_name, :password, :email])
        |> validate_format(:email, ~r/@/)
        |> validate_inclusion(:age, 0..130)
    end

    def create(params \\ %{}) do
        person = %DbConnector.Person{}
        changeset = DbConnector.Person.changeset(person, params)
        case DbConnector.Repo.insert(changeset) do
            {:ok, person} ->
              # do something with person
              Logger.info "person: #{inspect(person)}"
            {:error, changeset} ->
              # do something with changeset
              Logger.error "person: #{inspect(changeset)}"
          end
    end

    def getAllPeople(params \\ %{}) do
        people =  DbConnector.Person |> DbConnector.Repo.all
        Logger.info "person: #{inspect(people)}"
        {:ok, people}
        # case DbConnector.Person |> DbConnector.Repo.all do
        #     {:ok, person} ->
        #       Logger.info "person: #{inspect(person)}"
        #       {:ok, person}
        #     {:error, err} ->
        #       Logger.error "err: #{inspect(err)}"
        #   end
 
    end

end