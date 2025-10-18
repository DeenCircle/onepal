defmodule OnepalWeb.ActiviyControllerTest do
  use OnepalWeb.ConnCase

  import Onepal.ActivitiesFixtures

  @create_attrs %{title: "some title", paragraph: "some paragraph"}
  @update_attrs %{title: "some updated title", paragraph: "some updated paragraph"}
  @invalid_attrs %{title: nil, paragraph: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, ~p"/activities")
      assert html_response(conn, 200) =~ "Listing Activities"
    end
  end

  describe "new activiy" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/activities/new")
      assert html_response(conn, 200) =~ "New Activiy"
    end
  end

  describe "create activiy" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/activities", activiy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/activities/#{id}"

      conn = get(conn, ~p"/activities/#{id}")
      assert html_response(conn, 200) =~ "Activiy #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/activities", activiy: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activiy"
    end
  end

  describe "edit activiy" do
    setup [:create_activiy]

    test "renders form for editing chosen activiy", %{conn: conn, activiy: activiy} do
      conn = get(conn, ~p"/activities/#{activiy}/edit")
      assert html_response(conn, 200) =~ "Edit Activiy"
    end
  end

  describe "update activiy" do
    setup [:create_activiy]

    test "redirects when data is valid", %{conn: conn, activiy: activiy} do
      conn = put(conn, ~p"/activities/#{activiy}", activiy: @update_attrs)
      assert redirected_to(conn) == ~p"/activities/#{activiy}"

      conn = get(conn, ~p"/activities/#{activiy}")
      assert html_response(conn, 200) =~ "some updated paragraph"
    end

    test "renders errors when data is invalid", %{conn: conn, activiy: activiy} do
      conn = put(conn, ~p"/activities/#{activiy}", activiy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activiy"
    end
  end

  describe "delete activiy" do
    setup [:create_activiy]

    test "deletes chosen activiy", %{conn: conn, activiy: activiy} do
      conn = delete(conn, ~p"/activities/#{activiy}")
      assert redirected_to(conn) == ~p"/activities"

      assert_error_sent 404, fn ->
        get(conn, ~p"/activities/#{activiy}")
      end
    end
  end

  defp create_activiy(%{scope: scope}) do
    activiy = activiy_fixture(scope)

    %{activiy: activiy}
  end
end
