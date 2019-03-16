defmodule DbConnector.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, unique: true, null: false
      add :email_token, :string
      add :password_hash, :string
      add :email_validated, :boolean, default: false
      add :age, :integer,
      add :token, :text

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:people, [:email])

  end
end
