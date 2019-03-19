defmodule Person.Helpers.AuthHelper do
    @moduledoc false
  
    import Bcrypt, only: [check_pass: 2, verify_pass: 2]
    alias DbConnector.Repo
    alias DbConnector.Person

    def login_with_email_pass(email, given_pass) do
      person = Repo.get_by(Person, email: String.downcase(email))
      cond do
        person && verify_pass(given_pass, person.password_hash) ->
          {:ok, person}
  
        person ->
          {:error, "Incorrect login credentials"}
  
        true ->
          {:error, :"Person not found"}
      end
    end

  end