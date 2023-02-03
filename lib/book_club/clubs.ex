defmodule BookClub.Clubs do
  @moduledoc """
  The Clubs context.
  """

  import Ecto.Query, warn: false
  alias BookClub.Repo

  alias BookClub.Clubs.Club

  @doc """
  Returns the list of clubs.

  ## Examples

      iex> list_clubs()
      [%Club{}, ...]

  """
  def list_clubs do
    Repo.all(Club)
    |> Repo.preload(:members)
  end

  @doc """
  Gets a single club.

  Raises `Ecto.NoResultsError` if the Club does not exist.

  ## Examples

      iex> get_club!(123)
      %Club{}

      iex> get_club!(456)
      ** (Ecto.NoResultsError)

  """
  def get_club!(id) do
    Repo.get!(Club, id)
    |> Repo.preload(:members)
  end

  @doc """
  Creates a club.

  ## Examples

      iex> create_club(%{field: value})
      {:ok, %Club{}}

      iex> create_club(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_club(attrs \\ %{}, member_emails \\ []) do
    IO.inspect(member_emails, label: "emails")
    IO.inspect(load_new_members(member_emails), label: "loaded_emails")
    %Club{}
    |> Club.changeset(attrs)
    |> IO.inspect(label: "before")
    |> Ecto.Changeset.put_assoc(:members, load_new_members(member_emails))
    |> IO.inspect(label: "after")
    |> Repo.insert()
    # |> Repo.preload(:members)
  end


defp load_new_members(emails) do
  # Should we assume that are all valid members?
  # get_user_by_email will just return nil, so not sure it matters.
  emails
  |> Enum.map(fn email -> BookClub.Accounts.get_user_by_email(email) end)
  |> Enum.filter(fn member -> member != nil end)
end

  @doc """
  Updates a club.

  ## Examples

      iex> update_club(club, %{field: new_value})
      {:ok, %Club{}}

      iex> update_club(club, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_club(%Club{} = club, attrs) do
    club
    |> Repo.preload(:members)
    |> Club.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Joins a club for a user_email.

  ## Examples

      iex> join_club(club, "real_user@email.com")
      {:ok, %Club{}}

      iex> join_club(club, "bad_user@email.com")
      {:error, %Ecto.Changeset{}}

  """
  def join_club(%Club{} = club, user_email) do
    club
    |> Repo.preload(:members)
    |> Ecto.Changeset.put_assoc(:members, load_new_members([user_email]))
    |> Repo.update()
    
  end

  @doc """
  Deletes a club.

  ## Examples

      iex> delete_club(club)
      {:ok, %Club{}}

      iex> delete_club(club)
      {:error, %Ecto.Changeset{}}

  """
  def delete_club(%Club{} = club) do
    Repo.delete(club)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking club changes.

  ## Examples

      iex> change_club(club)
      %Ecto.Changeset{data: %Club{}}

  """
  def change_club(%Club{} = club, attrs \\ %{}) do
    Club.changeset(club, attrs)
  end
end
