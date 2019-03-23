defmodule Person.Resolvers do
    require Logger
    alias DbConnector.Person, as: PersonModel
    alias DbConnector.Repo
    alias Person.Helpers.AuthHelper
    alias Person.Helpers.Person , as: PersonHelper
    import Ecto.Query, warn: false

    @moduledoc """
    Documentation for Person.
    """
  
    @doc """
    getAllPeople.
    get all the person record
    """
    def getAllPeople(_parent, _args, _resolution) do
      people =  PersonModel |> Repo.all
      Logger.info "person: #{inspect(people)}"
      {:ok, people}
    end
  
    def signUp(_parent, %{input: input}, _resolution) do
      changeset = PersonModel.changeset(%PersonModel{}, input)|> PersonModel.put_email_token()
      case Repo.insert(changeset) do
        {:ok, %{id: id}} ->
          Logger.info "id person: #{inspect(id)}"
          standard_reponse = %{status: "done", message: "sign up success, id : #{id}"}
          {:ok, standard_reponse}
        {:error, changeset} ->
          Logger.error "error: #{inspect(changeset)}"
          standard_reponse = %{status: "error", message: inspect(changeset.errors)}
          {:ok, standard_reponse}
      end
      
    end

    def create(args, %{context: %{current_user: _current_user}}) do
      PersonHelper.create_user(args)
    end
  
    def create(_args, _info) do
      {:error, "Not Authorized"}
    end

    @doc """
    findByEmail.
    find a person by email, protected by JWT authorization
    """
    def findByEmail(%{email: email}, %{context: %{current_user: current_user}}) do
      Logger.info "current_user: #{inspect(current_user)}"
      case PersonHelper.get_user_by_email(email) do
        nil -> {:error, "email #{email} not found"}
        person -> {:ok, person}
        _ -> {:error, "An error occured"}
      end
    end

    @doc """
    findByEmail default implementation
    find a person by email, protected by JWT authorization
    """
    def findByEmail(_args, _info) do
      {:error, "Not Authorized"}
    end

    @doc """
    signin resolver, return the JWT token.
    find a person by email, protected by JWT authorization
    """
    def signIn(_parent,%{input: %{email: email, password: password}}, _info) do
      with {:ok, person} <- AuthHelper.login_with_email_pass(email, password),
           {:ok, jwt, _} <- FrontWeb.Guardian.encode_and_sign(person),
           {:ok, _} <- PersonHelper.store_token(person, jwt) do
        {:ok, %{token: jwt}}
      end
    end

    @doc """
    signin resolver, return the JWT token.
    find a person by email, protected by JWT authorization
    """
    def signOut(_args,  %{context: %{current_person: current_person, token: _token}}) do
      PersonHelper.revoke_token(current_person, nil)
      {:ok, current_person}
    end
  
    def signOut(_args, _info) do
      {:error, "Please log in first!"}
    end
  
  
  
  end
  