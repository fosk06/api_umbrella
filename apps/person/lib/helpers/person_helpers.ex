defmodule Person.Helpers.Person do
    @moduledoc """
    The boundary for the Accounts system.
    """
    require Logger
    import Ecto.Query, warn: false
    alias DbConnector.Repo
    alias DbConnector.Person
  
    @doc """
    Returns the list of users.
  
    ## Examples
  
        iex> list_persons()
        [%Person{}, ...]
  
    """
    def list_persons do
      Repo.all(Person)
    end
  
    @doc """
    Gets a single person.
  
    Raises `Ecto.NoResultsError` if the Person does not exist.
  
    ## Examples
  
        iex> get_person!(123)
        %Person{}
  
        iex> get_person!(456)
        ** (Ecto.NoResultsError)
  
    """
    def get_person!(id), do: Repo.get!(Person, id)
  
    def get_person_by_email(email), do: Repo.one(from(u in Person, where: u.email == ^email))
  
    @doc """
    Creates a person.
  
    ## Examples
  
        iex> create_person(%{field: value})
        {:ok, %Person{}}
  
        iex> create_person(%{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def create_person(attrs \\ %{}) do
      %Person{}
      |> Person.changeset(attrs)
      |> Repo.insert()
    end
  
    @doc """
    Updates a person.
  
    ## Examples
  
        iex> update_person(person, %{field: new_value})
        {:ok, %Person{}}
  
        iex> update_person(person, %{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def update_person(%Person{} = person, attrs) do
      person
      |> Person.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a Person.
  
    ## Examples
  
        iex> delete_person(person)
        {:ok, %Person{}}
  
        iex> delete_person(person)
        {:error, %Ecto.Changeset{}}
  
    """
    def delete_person(%Person{} = person) do
      Repo.delete(person)
    end
  
    @doc """
    Returns an `%Ecto.Changeset{}` for tracking person changes.
  
    ## Examples
  
        iex> change_person(person)
        %Ecto.Changeset{source: %Person{}}
  
    """
    def change_person(%Person{} = person) do
      Person.changeset(person, %{})
    end
  
    def store_token(%Person{} = person, token) do
      # Logger.info "store_token: #{inspect(token)}"
      person
      |> Person.store_token_changeset(%{token: token})
      |> Repo.update()
    end
  
    def revoke_token(%Person{} = person, token) do
      Logger.info "person: #{inspect(person)}"
      Logger.info "token: #{inspect(token)}"
      person
      |> Person.store_token_changeset(%{token: token})
      |> Repo.update()
    end

    def revoke_token(_person, _token) do
      Logger.info "revoke_token default"
      nil
    end

  end