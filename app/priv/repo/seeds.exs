# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Onepal.Repo.insert!(%Onepal.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Onepal.Accounts.User
alias Onepal.Repo

user = %User{
  email: "admin@onepal.com",
  first_name: "admin",
  last_name: "admin",
  hashed_password: "unhashed"
}

user = User.password_changeset(user, %{password: "admin_password"})
Repo.insert(user)
