defmodule Onepal.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :paragraph, :string
    field :title, :string
    field :created_by, :id
    field :updated_by, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity, attrs, user_scope) do
    activity
    |> cast(attrs, [:paragraph, :title])
    |> validate_required([:paragraph, :title])
    |> put_change(:user_id, user_scope.user.id)
  end
end
