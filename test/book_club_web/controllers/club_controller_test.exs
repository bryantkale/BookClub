defmodule BookClubWeb.ClubControllerTest do
  use BookClubWeb.ConnCase

  import BookClub.ClubsFixtures
  import BookClub.AccountsFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    setup [:register_and_log_in_user]

    test "lists all clubs", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Clubs"
    end
  end

  describe "new club" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :new))
      assert html_response(conn, 200) =~ "New Club"
    end
  end

  describe "create club" do
    setup [:register_and_log_in_user]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.club_path(conn, :create), club: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.club_path(conn, :show, id)

      conn = get(conn, Routes.club_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Club"
      assert html_response(conn, 200) =~ get_user_from_conn(conn).email
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.club_path(conn, :create), club: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Club"
    end
  end

  describe "edit club" do
    setup [:create_club, :register_and_log_in_user]

    test "renders form for editing chosen club", %{conn: conn, club: club} do
      conn = get(conn, Routes.club_path(conn, :edit, club))
      assert html_response(conn, 200) =~ "Edit Club"
    end
  end

  describe "update club" do
    setup [:create_club, :register_and_log_in_user]

    test "redirects when data is valid", %{conn: conn, club: club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: @update_attrs)
      assert redirected_to(conn) == Routes.club_path(conn, :show, club)

      conn = get(conn, Routes.club_path(conn, :show, club))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, club: club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Club"
    end
  end

  describe "join club" do
    setup [:register_and_log_in_user]

    test "new user can join existing club", %{conn: conn} do
      orig_email = get_user_from_conn(conn).email
      club = club_fixture(@create_attrs, [orig_email])

      new_user = user_fixture()
      conn = log_in_user(conn, new_user)
      conn = put(conn, Routes.club_path(conn, :join_club, club))
      assert redirected_to(conn) == Routes.club_path(conn, :show, club)

      conn = get(conn, Routes.club_path(conn, :show, club))
      assert html_response(conn, 200) =~ new_user.email
      assert html_response(conn, 200) =~ orig_email
    end
  end

  describe "leave club" do
    setup [:register_and_log_in_user]

    test "new user can join and leave existing club", %{conn: conn} do
      orig_email = get_user_from_conn(conn).email
      club = club_fixture(@create_attrs, [orig_email])
      conn = put(conn, Routes.club_path(conn, :leave_club, club))
      assert redirected_to(conn) == Routes.club_path(conn, :show, club)
      conn = get(conn, Routes.club_path(conn, :show, club))
      assert html_response(conn, 200) =~ "Left club successfully"
    end

    test "new user can't leave club without first joining", %{conn: conn} do
      club = club_fixture(@create_attrs, [])
      conn = put(conn, Routes.club_path(conn, :leave_club, club))
      assert redirected_to(conn) == Routes.club_path(conn, :show, club)
      conn = get(conn, Routes.club_path(conn, :show, club))
      assert html_response(conn, 200) =~ "Could not leave club"
    end
  end

  describe "delete club" do
    setup [:create_club, :register_and_log_in_user]

    test "deletes chosen club", %{conn: conn, club: club} do
      conn = delete(conn, Routes.club_path(conn, :delete, club))
      assert redirected_to(conn) == Routes.club_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.club_path(conn, :show, club))
      end
    end
  end

  defp create_club(_) do
    club = club_fixture()
    %{club: club}
  end
end
