defmodule BookClub.ClubsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookClub.Clubs` context.
  """

  @doc """
  Generate a club.
  """
  def club_fixture(attrs \\ %{}) do
    {:ok, club} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> BookClub.Clubs.create_club()

    club
  end
end
