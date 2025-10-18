defmodule OnepalWeb.ActiviyController do
  use OnepalWeb, :controller

  alias Onepal.Activities
  alias Onepal.Activities.Activiy

  def index(conn, _params) do
    activities = Activities.list_activities(conn.assigns.current_scope)
    render(conn, :index, activities: activities)
  end

  def new(conn, _params) do
    changeset =
      Activities.change_activiy(conn.assigns.current_scope, %Activiy{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"activiy" => activiy_params}) do
    case Activities.create_activiy(conn.assigns.current_scope, activiy_params) do
      {:ok, activiy} ->
        conn
        |> put_flash(:info, "Activiy created successfully.")
        |> redirect(to: ~p"/activities/#{activiy}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activiy = Activities.get_activiy!(conn.assigns.current_scope, id)
    render(conn, :show, activiy: activiy)
  end

  def edit(conn, %{"id" => id}) do
    activiy = Activities.get_activiy!(conn.assigns.current_scope, id)
    changeset = Activities.change_activiy(conn.assigns.current_scope, activiy)
    render(conn, :edit, activiy: activiy, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activiy" => activiy_params}) do
    activiy = Activities.get_activiy!(conn.assigns.current_scope, id)

    case Activities.update_activiy(conn.assigns.current_scope, activiy, activiy_params) do
      {:ok, activiy} ->
        conn
        |> put_flash(:info, "Activiy updated successfully.")
        |> redirect(to: ~p"/activities/#{activiy}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, activiy: activiy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activiy = Activities.get_activiy!(conn.assigns.current_scope, id)
    {:ok, _activiy} = Activities.delete_activiy(conn.assigns.current_scope, activiy)

    conn
    |> put_flash(:info, "Activiy deleted successfully.")
    |> redirect(to: ~p"/activities")
  end
end
