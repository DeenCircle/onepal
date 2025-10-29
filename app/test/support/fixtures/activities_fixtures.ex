defmodule Onepal.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Onepal.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        paragraph: "some paragraph",
        title: "some title"
      })

    {:ok, activity} = Onepal.Activities.create_activity(scope, attrs)
    activity
  end
end
