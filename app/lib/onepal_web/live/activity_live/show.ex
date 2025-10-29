defmodule OnepalWeb.ActivityLive.Show do
  use OnepalWeb, :live_view

  alias Onepal.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Activity {@activity.id}
        <:subtitle>This is a activity record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/activities"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/activities/#{@activity}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit activity
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Paragraph">{@activity.paragraph}</:item>
        <:item title="Title">{@activity.title}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe_activities(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Activity")
     |> assign(:activity, Activities.get_activity!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Onepal.Activities.Activity{id: id} = activity},
        %{assigns: %{activity: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :activity, activity)}
  end

  def handle_info(
        {:deleted, %Onepal.Activities.Activity{id: id}},
        %{assigns: %{activity: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current activity was deleted.")
     |> push_navigate(to: ~p"/activities")}
  end

  def handle_info({type, %Onepal.Activities.Activity{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
