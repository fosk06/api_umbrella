defmodule Person do
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

end
