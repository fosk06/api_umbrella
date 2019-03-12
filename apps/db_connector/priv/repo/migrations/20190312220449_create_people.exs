defmodule DbConnector.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :email_token, :string
      add :password, :string
      add :email_validated, :boolean, default: false
      add :age, :integer
    end
  end
end
