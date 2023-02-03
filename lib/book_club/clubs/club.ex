defmodule BookClub.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :description, :string
    field :name, :string

    many_to_many :members, BookClub.Accounts.User, join_through: BookClub.Clubs.Member
    timestamps()
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
