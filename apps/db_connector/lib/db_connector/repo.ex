defmodule DbConnector.Repo do
  use Ecto.Repo,
    otp_app: :db_connector,
    adapter: Ecto.Adapters.Postgres
end
