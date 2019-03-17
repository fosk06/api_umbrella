defmodule Person.Resolvers do
    alias DbConnector.Person, as: PersonModel
    alias DbConnector.Repo
  
    @moduledoc """
    Documentation for Person.
    """
  
    @doc """
    getAllPeople.
    get all the person record
    """
    def getAllPeople(_parent, _args, _resolution) do
      people =  DbConnector.Person |> DbConnector.Repo.all
      Logger.info "person: #{inspect(people)}"
      {:ok, people}
    end
  
    def signUp(_parent, %{input: input}, _resolution) do
      changeset = PersonModel.changeset(%PersonModel{}, input)|> DbConnector.Person.put_email_token()
      case Repo.insert(changeset) do
        {:ok, %{id: id}} ->
          # Logger.info "id person: #{inspect(id)}"
          standard_reponse = %{status: "done", message: "sign up success, id : #{id}"}
          {:ok, standard_reponse}
        {:error, changeset} ->
          Logger.error "error: #{inspect(changeset)}"
          standard_reponse = %{status: "error", message: inspect(changeset.errors)}
          {:ok, standard_reponse}
      end
      
    end
  
  
  end
  