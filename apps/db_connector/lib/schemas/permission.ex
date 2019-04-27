defmodule DbConnector.Permission do
    @moduledoc false
    
    require Logger
    use Ecto.Schema
    import Ecto.Changeset
    import EctoEnum
    alias DbConnector.{RoleEnum, OperationEnum}

    schema "permission" do
      field :operation_type, OperationEnum
      field :role, RoleEnum
      field :operation_name, :string
      
      timestamps(type: :utc_datetime_usec)
    end

    def changeset(person, params \\ %{}) do
        person
        |> cast(params, [:operation_type,:role, :operation_name])
        |> validate_required([:operation_type, :role, :operation_name])
        |> validate_length(:operation_name, min: 3)
    end

end