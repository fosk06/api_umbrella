defmodule Person.Helpers.AuthHelper do
    @moduledoc false
  
    import Bcrypt, only: [check_pass: 2]
    alias DbConnector.Repo
    alias DbConnector.Person

    def login_with_email_pass(email, given_pass) do
      person = Repo.get_by(Person, email: String.downcase(email))
      cond do
        person && checkpw(given_pass, person.password_hash) ->
          {:ok, person}
  
        person ->
          {:error, "Incorrect login credentials"}
  
        true ->
          {:error, :"Person not found"}
      end
    end

    def authenticate_user(email, plain_text_password) do
      query = from u in Person, where: u.email == ^email
      case Repo.one(query) do
        nil ->
          Bcrypt.no_user_verify()
          {:error, :invalid_credentials}
        person ->
          if Bcrypt.verify_pass(plain_text_password, person.password) do
            {:ok, person}
          else
            {:error, :invalid_credentials}
          end
      end
    end

  end