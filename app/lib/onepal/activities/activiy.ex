defmodule Onepal.Activities.Activiy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :paragraph, :string
    field :title, :string
    field :user_id, :id
    # TODO: fix the audit issue (Ahmed, 18/10/2)
    field :created_by, :id
    field :updated_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activiy, attrs, user_scope) do
    activiy
    |> cast(attrs, [:paragraph, :title])
    |> validate_required([:paragraph, :title])
    |> put_change(:user_id, user_scope.user.id)
  end
end
