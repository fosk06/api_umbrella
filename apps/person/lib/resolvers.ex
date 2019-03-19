defmodule Person.Resolvers do
    require Logger
    alias DbConnector.Person, as: PersonModel
    alias DbConnector.Repo
    alias Person.Helpers.AuthHelper
    alias Person.Helpers.Person , as: PersonHelper
  
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

    def find(%{email: email}, %{context: %{current_user: _current_user}}) do
      case PersonHelper.get_user_by_email(email) do
        nil -> {:error, "User email #{email} not found!"}
        user -> {:ok, user}
      end
    end

    def signIn(_parent,%{input: %{email: email, password: password}}, _info) do
      with {:ok, person} <- AuthHelper.login_with_email_pass(email, password),
           {:ok, jwt, _} <- Front.Guardian.encode_and_sign(person),
           {:ok, _} <- PersonHelper.store_token(person, jwt) do
        {:ok, %{token: jwt}}
      end
    end

    def signOut(_args,  %{context: %{current_user: current_user, token: _token}}) do
      PersonHelper.revoke_token(current_user, nil)
      {:ok, current_user}
    end
  
    def signOut(_args, _info) do
      {:error, "Please log in first!"}
    end
  
  
  
  end
  