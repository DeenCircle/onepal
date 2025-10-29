defmodule OnepalWeb.ActivityLive.Form do
  use OnepalWeb, :live_view

  alias Onepal.Activities
  alias Onepal.Activities.Activity

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage activity records in your database.</:subtitle>
      </.header>
      <.form for={@form} id="activity-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:paragraph]} type="textarea" label="Paragraph" />
        <.input field={@form[:title]} type="text" label="Title" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Activity</.button>
          <.button navigate={return_path(@current_scope, @return_to, @activity)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    activity = Activities.get_activity!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, activity)
    |> assign(:form, to_form(Activities.change_activity(socket.assigns.current_scope, activity)))
  end

  defp apply_action(socket, :new, _params) do
    activity = %Activity{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, activity)
    |> assign(:form, to_form(Activities.change_activity(socket.assigns.current_scope, activity)))
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      Activities.change_activity(
        socket.assigns.current_scope,
        socket.assigns.activity,
        activity_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"activity" => activity_params}, socket) do
    save_activity(socket, socket.assigns.live_action, activity_params)
  end

  defp save_activity(socket, :edit, activity_params) do
    case Activities.update_activity(
           socket.assigns.current_scope,
           socket.assigns.activity,
           activity_params
         ) do
      {:ok, activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, activity)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    case Activities.create_activity(socket.assigns.current_scope, activity_params) do
      {:ok, activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, activity)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _activity), do: ~p"/activities"
  defp return_path(_scope, "show", activity), do: ~p"/activities/#{activity}"
end
