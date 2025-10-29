defmodule OnepalWeb.ActivityLive.Index do
  use OnepalWeb, :live_view

  alias Onepal.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component :if={@live_action == :new} module={OnepalWeb.ActivityLive.Form} id="form" />
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Activities
        <:actions>
          <.button variant="primary" navigate={~p"/activities/new"}>
            <.icon name="hero-plus" /> New Activity
          </.button>
        </:actions>
      </.header>
      bro what?
      <.table
        id="activities"
        rows={@streams.activities}
        row_click={fn {_id, activity} -> JS.navigate(~p"/activities/#{activity}") end}
      >
        <:col :let={{_id, activity}} label="Paragraph">{activity.paragraph}</:col>
        <:col :let={{_id, activity}} label="Title">{activity.title}</:col>
        <:action :let={{_id, activity}}>
          <div class="sr-only">
            <.link navigate={~p"/activities/#{activity}"}>Show</.link>
          </div>
          <.link navigate={~p"/activities/#{activity}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, activity}}>
          <.link
            phx-click={JS.push("delete", value: %{id: activity.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Activities.subscribe_activities(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Activities")
     |> stream(:activities, list_activities(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(socket.assigns.current_scope, id)
    {:ok, _} = Activities.delete_activity(socket.assigns.current_scope, activity)

    {:noreply, stream_delete(socket, :activities, activity)}
  end

  @impl true
  def handle_info({type, %Onepal.Activities.Activity{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :activities, list_activities(socket.assigns.current_scope), reset: true)}
  end

  defp list_activities(current_scope) do
    Activities.list_activities(current_scope)
  end
end
