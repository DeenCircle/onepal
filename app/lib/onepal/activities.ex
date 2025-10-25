defmodule Onepal.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Onepal.Repo

  alias Onepal.Activities.Activiy
  alias Onepal.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any activiy changes.

  The broadcasted messages match the pattern:

    * {:created, %Activiy{}}
    * {:updated, %Activiy{}}
    * {:deleted, %Activiy{}}

  """
  def subscribe_activities(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Onepal.PubSub, "user:#{key}:activities")
  end

  defp broadcast_activiy(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Onepal.PubSub, "user:#{key}:activities", message)
  end

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities(scope)
      [%Activiy{}, ...]

  """
  def list_activities(%Scope{} = scope) do
    Repo.all_by(Activiy, user_id: scope.user.id)
  end

  @doc """
  Gets a single activiy.

  Raises `Ecto.NoResultsError` if the Activiy does not exist.

  ## Examples

      iex> get_activiy!(scope, 123)
      %Activiy{}

      iex> get_activiy!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_activiy!(%Scope{} = scope, id) do
    Repo.get_by!(Activiy, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a activiy.

  ## Examples

      iex> create_activiy(scope, %{field: value})
      {:ok, %Activiy{}}

      iex> create_activiy(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activiy(%Scope{} = scope, attrs) do
    with {:ok, activiy = %Activiy{}} <-
           %Activiy{}
           |> Activiy.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_activiy(scope, {:created, activiy})
      {:ok, activiy}
    end
  end

  @doc """
  Updates a activiy.

  ## Examples

      iex> update_activiy(scope, activiy, %{field: new_value})
      {:ok, %Activiy{}}

      iex> update_activiy(scope, activiy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activiy(%Scope{} = scope, %Activiy{} = activiy, attrs) do
    true = activiy.user_id == scope.user.id

    with {:ok, activiy = %Activiy{}} <-
           activiy
           |> Activiy.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_activiy(scope, {:updated, activiy})
      {:ok, activiy}
    end
  end

  @doc """
  Deletes a activiy.

  ## Examples

      iex> delete_activiy(scope, activiy)
      {:ok, %Activiy{}}

      iex> delete_activiy(scope, activiy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activiy(%Scope{} = scope, %Activiy{} = activiy) do
    true = activiy.user_id == scope.user.id

    with {:ok, activiy = %Activiy{}} <-
           Repo.delete(activiy) do
      broadcast_activiy(scope, {:deleted, activiy})
      {:ok, activiy}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activiy changes.

  ## Examples

      iex> change_activiy(scope, activiy)
      %Ecto.Changeset{data: %Activiy{}}

  """
  def change_activiy(%Scope{} = scope, %Activiy{} = activiy, attrs \\ %{}) do
    true = activiy.user_id == scope.user.id

    Activiy.changeset(activiy, attrs, scope)
  end
end
