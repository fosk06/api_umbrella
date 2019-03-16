defmodule DbConnector.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string, unique: true
      add :email_token, :string
      add :password, :string
      add :email_validated, :boolean, default: false
      add :age, :integer

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:people, [:email])

  end
end
