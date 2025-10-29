defmodule OnepalWeb.ActivityLiveTest do
  use OnepalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Onepal.ActivitiesFixtures

  @create_attrs %{title: "some title", paragraph: "some paragraph"}
  @update_attrs %{title: "some updated title", paragraph: "some updated paragraph"}
  @invalid_attrs %{title: nil, paragraph: nil}

  setup :register_and_log_in_user

  defp create_activity(%{scope: scope}) do
    activity = activity_fixture(scope)

    %{activity: activity}
  end

  describe "Index" do
    setup [:create_activity]

    test "lists all activities", %{conn: conn, activity: activity} do
      {:ok, _index_live, html} = live(conn, ~p"/activities")

      assert html =~ "Listing Activities"
      assert html =~ activity.paragraph
    end

    test "saves new activity", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Activity")
               |> render_click()
               |> follow_redirect(conn, ~p"/activities/new")

      assert render(form_live) =~ "New Activity"

      assert form_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#activity-form", activity: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity created successfully"
      assert html =~ "some paragraph"
    end

    test "updates activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#activities-#{activity.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/activities/#{activity}/edit")

      assert render(form_live) =~ "Edit Activity"

      assert form_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#activity-form", activity: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated paragraph"
    end

    test "deletes activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("#activities-#{activity.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activities-#{activity.id}")
    end
  end

  describe "Show" do
    setup [:create_activity]

    test "displays activity", %{conn: conn, activity: activity} do
      {:ok, _show_live, html} = live(conn, ~p"/activities/#{activity}")

      assert html =~ "Show Activity"
      assert html =~ activity.paragraph
    end

    test "updates activity and returns to show", %{conn: conn, activity: activity} do
      {:ok, show_live, _html} = live(conn, ~p"/activities/#{activity}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/activities/#{activity}/edit?return_to=show")

      assert render(form_live) =~ "Edit Activity"

      assert form_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#activity-form", activity: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/activities/#{activity}")

      html = render(show_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated paragraph"
    end
  end
end
