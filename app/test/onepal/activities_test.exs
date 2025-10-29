defmodule Onepal.ActivitiesTest do
  use Onepal.DataCase

  alias Onepal.Activities

  describe "activities" do
    alias Onepal.Activities.Activity

    import Onepal.AccountsFixtures, only: [user_scope_fixture: 0]
    import Onepal.ActivitiesFixtures

    @invalid_attrs %{title: nil, paragraph: nil}

    test "list_activities/1 returns all scoped activities" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity = activity_fixture(scope)
      other_activity = activity_fixture(other_scope)
      assert Activities.list_activities(scope) == [activity]
      assert Activities.list_activities(other_scope) == [other_activity]
    end

    test "get_activity!/2 returns the activity with given id" do
      scope = user_scope_fixture()
      activity = activity_fixture(scope)
      other_scope = user_scope_fixture()
      assert Activities.get_activity!(scope, activity.id) == activity
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(other_scope, activity.id) end
    end

    test "create_activity/2 with valid data creates a activity" do
      valid_attrs = %{title: "some title", paragraph: "some paragraph"}
      scope = user_scope_fixture()

      assert {:ok, %Activity{} = activity} = Activities.create_activity(scope, valid_attrs)
      assert activity.title == "some title"
      assert activity.paragraph == "some paragraph"
      assert activity.user_id == scope.user.id
    end

    test "create_activity/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(scope, @invalid_attrs)
    end

    test "update_activity/3 with valid data updates the activity" do
      scope = user_scope_fixture()
      activity = activity_fixture(scope)
      update_attrs = %{title: "some updated title", paragraph: "some updated paragraph"}

      assert {:ok, %Activity{} = activity} = Activities.update_activity(scope, activity, update_attrs)
      assert activity.title == "some updated title"
      assert activity.paragraph == "some updated paragraph"
    end

    test "update_activity/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity = activity_fixture(scope)

      assert_raise MatchError, fn ->
        Activities.update_activity(other_scope, activity, %{})
      end
    end

    test "update_activity/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      activity = activity_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(scope, activity, @invalid_attrs)
      assert activity == Activities.get_activity!(scope, activity.id)
    end

    test "delete_activity/2 deletes the activity" do
      scope = user_scope_fixture()
      activity = activity_fixture(scope)
      assert {:ok, %Activity{}} = Activities.delete_activity(scope, activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(scope, activity.id) end
    end

    test "delete_activity/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activity = activity_fixture(scope)
      assert_raise MatchError, fn -> Activities.delete_activity(other_scope, activity) end
    end

    test "change_activity/2 returns a activity changeset" do
      scope = user_scope_fixture()
      activity = activity_fixture(scope)
      assert %Ecto.Changeset{} = Activities.change_activity(scope, activity)
    end
  end
end
