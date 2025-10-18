defmodule Onepal.ActivitiesTest do
  use Onepal.DataCase

  alias Onepal.Activities

  describe "activities" do
    alias Onepal.Activities.Activiy

    import Onepal.AccountsFixtures, only: [user_scope_fixture: 0]
    import Onepal.ActivitiesFixtures

    @invalid_attrs %{title: nil, paragraph: nil}

    test "list_activities/1 returns all scoped activities" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      other_activiy = activiy_fixture(other_scope)
      assert Activities.list_activities(scope) == [activiy]
      assert Activities.list_activities(other_scope) == [other_activiy]
    end

    test "get_activiy!/2 returns the activiy with given id" do
      scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      other_scope = user_scope_fixture()
      assert Activities.get_activiy!(scope, activiy.id) == activiy
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activiy!(other_scope, activiy.id) end
    end

    test "create_activiy/2 with valid data creates a activiy" do
      valid_attrs = %{title: "some title", paragraph: "some paragraph"}
      scope = user_scope_fixture()

      assert {:ok, %Activiy{} = activiy} = Activities.create_activiy(scope, valid_attrs)
      assert activiy.title == "some title"
      assert activiy.paragraph == "some paragraph"
      assert activiy.user_id == scope.user.id
    end

    test "create_activiy/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.create_activiy(scope, @invalid_attrs)
    end

    test "update_activiy/3 with valid data updates the activiy" do
      scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      update_attrs = %{title: "some updated title", paragraph: "some updated paragraph"}

      assert {:ok, %Activiy{} = activiy} = Activities.update_activiy(scope, activiy, update_attrs)
      assert activiy.title == "some updated title"
      assert activiy.paragraph == "some updated paragraph"
    end

    test "update_activiy/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activiy = activiy_fixture(scope)

      assert_raise MatchError, fn ->
        Activities.update_activiy(other_scope, activiy, %{})
      end
    end

    test "update_activiy/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Activities.update_activiy(scope, activiy, @invalid_attrs)
      assert activiy == Activities.get_activiy!(scope, activiy.id)
    end

    test "delete_activiy/2 deletes the activiy" do
      scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      assert {:ok, %Activiy{}} = Activities.delete_activiy(scope, activiy)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activiy!(scope, activiy.id) end
    end

    test "delete_activiy/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      assert_raise MatchError, fn -> Activities.delete_activiy(other_scope, activiy) end
    end

    test "change_activiy/2 returns a activiy changeset" do
      scope = user_scope_fixture()
      activiy = activiy_fixture(scope)
      assert %Ecto.Changeset{} = Activities.change_activiy(scope, activiy)
    end
  end
end
