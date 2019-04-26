defmodule DbConnector.Repo do
  @moduledoc false
  
  use Ecto.Repo,
    otp_app: :db_connector,
    adapter: Ecto.Adapters.Postgres
end
