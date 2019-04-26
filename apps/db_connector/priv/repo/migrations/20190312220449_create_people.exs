defmodule DbConnector.Repo.Migrations.CreatePeople do
  @moduledoc false
  
  use Ecto.Migration
  import EctoEnum

  alias DbConnector.RoleEnum

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, unique: true, null: false
      add :email_token, :string
      add :password_hash, :string
      add :email_validated, :boolean, default: false
      add :age, :integer
      add :token, :text
      add :role, :integer
      timestamps(type: :utc_datetime_usec)
    end

    create table(:permission) do
      add :operation_type, :integer
      add :role, :integer
      add :value, :string, null: false
      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:people, [:email])

  end

end
