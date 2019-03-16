defmodule Person do
  alias DbConnector.Person, as: PersonModel
  alias DbConnector.Repo

  @moduledoc """
  Documentation for Person.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Person.hello()
      :world

  """
  require Logger

  def hello do
    :world
  end

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
    uuid = UUID.uuid4()
    person = %PersonModel{}
    person = Map.put(person, :inserted_at, DateTime.utc_now)
    person = Map.put(person, :updated_at, DateTime.utc_now)
    person = Map.put(person, :email_token, uuid)
    Logger.info "person signup: #{inspect(person)}"
    changeset = PersonModel.changeset(person, input)
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
