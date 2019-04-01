defmodule DbConnector.Role do
    require Logger
    use Ecto.Schema
    import Ecto.Changeset
    import EctoEnum
    alias DbConnector.{RoleEnum, OperationEnum}

    schema "people" do
      field :operation_type, OperationEnum
      field :role, RoleEnum
      field :value, :string
      
      timestamps(type: :utc_datetime_usec)
    end

    def changeset(person, params \\ %{}) do
        person
        |> cast(params, [:operation_type,:role, :value])
        |> validate_required([:operation_type, :role, :value])
        |> validate_length(:value, min: 3)
    end

end