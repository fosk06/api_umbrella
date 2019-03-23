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
  
        iex> list_users()
        [%Person{}, ...]
  
    """
    def list_users do
      Repo.all(Person)
    end
  
    @doc """
    Gets a single user.
  
    Raises `Ecto.NoResultsError` if the Person does not exist.
  
    ## Examples
  
        iex> get_user!(123)
        %Person{}
  
        iex> get_user!(456)
        ** (Ecto.NoResultsError)
  
    """
    def get_user!(id), do: Repo.get!(Person, id)
  
    def get_user_by_email(email), do: Repo.one(from(u in Person, where: u.email == ^email))
  
    @doc """
    Creates a user.
  
    ## Examples
  
        iex> create_user(%{field: value})
        {:ok, %Person{}}
  
        iex> create_user(%{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def create_user(attrs \\ %{}) do
      %Person{}
      |> Person.changeset(attrs)
      |> Repo.insert()
    end
  
    @doc """
    Updates a user.
  
    ## Examples
  
        iex> update_user(user, %{field: new_value})
        {:ok, %Person{}}
  
        iex> update_user(user, %{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def update_user(%Person{} = user, attrs) do
      user
      |> Person.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a Person.
  
    ## Examples
  
        iex> delete_user(user)
        {:ok, %Person{}}
  
        iex> delete_user(user)
        {:error, %Ecto.Changeset{}}
  
    """
    def delete_user(%Person{} = user) do
      Repo.delete(user)
    end
  
    @doc """
    Returns an `%Ecto.Changeset{}` for tracking user changes.
  
    ## Examples
  
        iex> change_user(user)
        %Ecto.Changeset{source: %Person{}}
  
    """
    def change_user(%Person{} = user) do
      Person.changeset(user, %{})
    end
  
    def store_token(%Person{} = user, token) do
      # Logger.info "store_token: #{inspect(token)}"
      user
      |> Person.store_token_changeset(%{token: token})
      |> Repo.update()
    end
  
    def revoke_token(%Person{} = user, token) do
      user
      |> Person.store_token_changeset(%{token: token})
      |> Repo.update()
    end
  end