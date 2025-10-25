defmodule Onepal.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :paragraph, :text
      add :title, :string
      add :created_by, references(:users, on_delete: :nothing)
      add :updated_by, references(:users, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:activities, [:user_id])

    create index(:activities, [:created_by])
    create index(:activities, [:updated_by])
  end
end
