defmodule BookClub.Clubs.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "club_members" do
    field :role, :string
    field :club_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
