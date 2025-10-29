defmodule Onepal.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Onepal.Repo

  alias Onepal.Activities.Activity
  alias Onepal.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any activity changes.

  The broadcasted messages match the pattern:

    * {:created, %Activity{}}
    * {:updated, %Activity{}}
    * {:deleted, %Activity{}}

  """
  def subscribe_activities(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Onepal.PubSub, "user:#{key}:activities")
  end

  defp broadcast_activity(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Onepal.PubSub, "user:#{key}:activities", message)
  end

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities(scope)
      [%Activity{}, ...]

  """
  def list_activities(%Scope{} = scope) do
    Repo.all_by(Activity, user_id: scope.user.id)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(scope, 123)
      %Activity{}

      iex> get_activity!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(%Scope{} = scope, id) do
    Repo.get_by!(Activity, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(scope, %{field: value})
      {:ok, %Activity{}}

      iex> create_activity(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(%Scope{} = scope, attrs) do
    with {:ok, activity = %Activity{}} <-
           %Activity{}
           |> Activity.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_activity(scope, {:created, activity})
      {:ok, activity}
    end
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(scope, activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(scope, activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Scope{} = scope, %Activity{} = activity, attrs) do
    true = activity.user_id == scope.user.id

    with {:ok, activity = %Activity{}} <-
           activity
           |> Activity.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_activity(scope, {:updated, activity})
      {:ok, activity}
    end
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(scope, activity)
      {:ok, %Activity{}}

      iex> delete_activity(scope, activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Scope{} = scope, %Activity{} = activity) do
    true = activity.user_id == scope.user.id

    with {:ok, activity = %Activity{}} <-
           Repo.delete(activity) do
      broadcast_activity(scope, {:deleted, activity})
      {:ok, activity}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(scope, activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Scope{} = scope, %Activity{} = activity, attrs \\ %{}) do
    true = activity.user_id == scope.user.id

    Activity.changeset(activity, attrs, scope)
  end
end
