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

      changeset = PersonModel.changeset(%PersonModel{
        role: 2
      }, input)
      |> PersonModel.put_email_token()

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

    def create(args, %{context: %{current_person: _current_person}}) do
      PersonHelper.create_person(args)
    end
  
    def create(_args, _info) do
      {:error, "Not Authorized"}
    end

    @doc """
    findByEmail.
    find a person by email, protected by JWT authorization
    """
    def findByEmail(%{email: email}, %{context: %{current_person: current_person , token: token}}) do
      # Logger.info "token: #{inspect(token)}"
      case PersonHelper.get_person_by_email(email) do
        person -> {:ok, person}
        nil -> {:error, "email #{email} not found"}
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
    """
    def signIn(_parent,%{input: %{email: email, password: password}}, _info) do
      
      with {:ok, person} <- AuthHelper.login_with_email_pass(email, password),
           {:ok, jwt, _} <- FrontWeb.Guardian.encode_and_sign(person),
           {:ok, _} <- PersonHelper.store_token(person, jwt) do
        {:ok, %{token: jwt}}
      end
    end

    @doc """
    sign out resolver, return remove the JWT token from db
    """
    def signOut(_args,  %{context: %{current_person: current_person, token: _token}}) do
      PersonHelper.revoke_token(current_person[:current_person], nil)
      standard_reponse = %{status: "done", message: "sign out success"}
      {:ok, standard_reponse}
    end
  
    def signOut(_args, _info) do
      {:error, "Please log in first!"}
    end
  
  
  
  end
  