defmodule BookClubWeb.ClubController do
  use BookClubWeb, :controller

  alias BookClub.Clubs
  alias BookClub.Clubs.Club

  def index(conn, _params) do
    clubs = Clubs.list_clubs()
    render(conn, "index.html", clubs: clubs)
  end

  def new(conn, _params) do
    changeset = Clubs.change_club(%Club{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"club" => club_params}) do
    case Clubs.create_club(club_params, [conn.assigns.current_user.email]) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club created successfully.")
        |> redirect(to: Routes.club_path(conn, :show, club))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    render(conn, "show.html", club: club)
  end

  def edit(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    changeset = Clubs.change_club(club)
    render(conn, "edit.html", club: club, changeset: changeset)
  end

  def update(conn, %{"id" => id, "club" => club_params}) do
    club = Clubs.get_club!(id)

    case Clubs.update_club(club, club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club updated successfully.")
        |> redirect(to: Routes.club_path(conn, :show, club))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", club: club, changeset: changeset)
    end
  end

  def join_club(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)

    case Clubs.join_club(club, conn.assigns.current_user.email) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Joined club successfully.")
        |> redirect(to: Routes.club_path(conn, :show, club))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "show.html", club: club, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    {:ok, _club} = Clubs.delete_club(club)

    conn
    |> put_flash(:info, "Club deleted successfully.")
    |> redirect(to: Routes.club_path(conn, :index))
  end
end
