defmodule BookClub.ClubsTest do
  use BookClub.DataCase

  alias BookClub.Accounts
  alias BookClub.Clubs

  describe "clubs" do
    alias BookClub.Clubs.Club

    import BookClub.ClubsFixtures
    import BookClub.AccountsFixtures

    @invalid_attrs %{description: nil, name: nil}
    @invalid_email "fake@email.com"

    test "list_clubs/0 returns all clubs" do
      club = club_fixture()
      assert Clubs.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Clubs.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Club{} = club} = Clubs.create_club(valid_attrs)
      assert club.description == "some description"
      assert club.name == "some name"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clubs.create_club(@invalid_attrs)
    end

    test "join_club/2 with valid data joins a club" do
      club = club_fixture()
      assert Clubs.get_club!(club.id) == club
      new_user = user_fixture()
      assert Accounts.get_user_by_email(new_user.email) == new_user
      assert {:ok, %Club{} = club} = Clubs.join_club(club, new_user.email)
      assert Enum.member?(club.members, new_user)
    end

    test "join_club/2 with invalid email is a no-op" do
      club = club_fixture()
      assert {:ok, %Club{} = updated_club} = Clubs.join_club(club, @invalid_email)
      assert updated_club == club
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Club{} = club} = Clubs.update_club(club, update_attrs)
      assert club.description == "some updated description"
      assert club.name == "some updated name"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Clubs.update_club(club, @invalid_attrs)
      assert club == Clubs.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Clubs.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Clubs.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Clubs.change_club(club)
    end
  end
end
