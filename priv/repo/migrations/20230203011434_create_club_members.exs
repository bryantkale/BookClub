defmodule BookClub.Repo.Migrations.CreateClubMembers do
  use Ecto.Migration

  def change do
    create table(:club_members) do
      add :role, :string
      add :club_id, references(:clubs, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:club_members, [:club_id])
    create index(:club_members, [:user_id])
  end
end
