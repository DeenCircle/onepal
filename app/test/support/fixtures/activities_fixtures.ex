defmodule Onepal.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Onepal.Activities` context.
  """

  @doc """
  Generate a activiy.
  """
  def activiy_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        paragraph: "some paragraph",
        title: "some title"
      })

    {:ok, activiy} = Onepal.Activities.create_activiy(scope, attrs)
    activiy
  end
end
