defmodule Rtg.Accounts.User do
  @moduledoc false

  import Ecto.Changeset

  use Ecto.Schema

  schema "users" do
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
