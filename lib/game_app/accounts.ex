defmodule GameApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GameApp.Repo

  alias GameApp.Accounts.Player

  @doc """
  Retrieves all players from the database.

  This function queries the Player table and returns a list of all player records. It's a straightforward retrieval that does not apply any filters or conditions, so it will return all players stored in the database.

  ## Examples

      # Getting a list of all players
      iex> list_players()
      [%Player{id: 1, name: "Alice", email: "alice@example.com", score: 15},
       %Player{id: 2, name: "Bob", email: "bob@example.com", score: 12}]

  ## Returns

  - A list of `%Player{}` structs: This could be an empty list if no players are present in the database.

  """

  def list_players do
    Repo.all(Player)
  end

  @doc """
  Fetches a player by ID from the database.

  This function retrieves a player based on the provided ID. It directly queries the Player table in the database. If a player with the specified ID exists, it returns the player struct. If no player with such ID exists, it raises an `Ecto.NoResultsError`.

  ## Parameters

  - `id`: The ID of the player to retrieve. Typically, this is an integer value.

  ## Examples

      # Fetching a player with a valid ID
      iex> get_player!(5)
      %Player{id: 5, name: "Alice", email: "alice@example.com", score: 15}

      # Attempting to fetch a player with a non-existing ID
      iex> get_player!(9999)
      ** (Ecto.NoResultsError)

  ## Returns

  - `%Player{}`: The player record if found.
  - Raises `Ecto.NoResultsError` if no player with the given ID exists.

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a new player in the database.

  This function creates a new player using the provided attributes. It uses a changeset to validate the attributes against the Player schema before attempting to insert them into the database. If the attributes are valid, the new player is saved, and the function returns the newly created player struct. If there are validation errors or any other insertion issues, it returns an error changeset.

  ## Parameters

  - `attrs`: A map containing the attributes for the new player. Expected keys correspond to the fields defined in the Player schema, such as `name`, `email`, and `score`.

  ## Examples

      # Creating a player with valid attributes
      iex> create_player(%{"name" => "John Doe", "email" => "john@example.com", "score" => "20"})
      {:ok, %Player{name: "John Doe", email: "john@example.com", score: 20}}

      # Attempting to create a player with invalid attributes
      iex> create_player(%{"name" => nil, "email" => "john@example.com", "score" => "20"})
      {:error, %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}]}}

  ## Returns

  - `{:ok, %Player{}}`: Successfully created player.
  - `{:error, %Ecto.Changeset{}}`: The changeset did not validate or could not be saved to the database.

  """

  def create_player(attrs \\ %{}) do
    attrs
    |> Player.create_changeset()
    |> Repo.insert()
  end

  @doc """
  Updates a player, ensuring that the score only increases.

  This function updates a player's attributes while specifically ensuring that the player's score is updated to the maximum value between the existing score and any new score provided. If no new score is provided or the provided score is less than the current score, the current score is maintained.

  ## Parameters

  - `player`: The `%Player{}` struct to be updated.
  - `attrs`: A map of attributes to update. The `score` in `attrs` should be an integer or string that can be converted to an integer.

  ## Examples

      # When a higher score is provided
      iex> update_player(player, %{"score" => "30"})
      {:ok, %Player{score: 30}}

      # When a lower or equal score is provided
      iex> update_player(player, %{"score" => "15"})
      {:ok, %Player{score: 20}} # Assuming the current score was 20

      # When a non-integer score is provided
      iex> update_player(player, %{"score" => "bad_value"})
      {:error, %Ecto.Changeset{}}

  ## Returns

  - `{:ok, %Player{}}`: Successfully updated player.
  - `{:error, %Ecto.Changeset{}}`: The changeset did not validate or could not be saved to the database.

  """
  def update_player(%Player{} = player, attrs) do
    Repo.transaction(fn ->
      current_player = Repo.get!(Player, player.id)
      current_score = current_player.score

      new_score = attrs["score"] |> String.to_integer()

      max_score = max(current_score, new_score)

      changeset =
        player
        |> Player.update_changeset(attrs)
        |> Ecto.Changeset.put_change(:score, max_score)

      Repo.update!(changeset)
    end)
  end

  @doc """
  Deletes a specific player from the database.

  This function takes a player struct and deletes it from the database. It is essential to provide an existing player struct as the argument. If the deletion is successful, it returns an `:ok` tuple with the deleted player data. If the deletion fails (e.g., due to foreign key constraints or if the player does not exist), it returns an `:error` tuple.

  ## Parameters

  - `player`: A `%Player{}` struct representing the player to be deleted. The struct must already exist and be loaded from the database.

  ## Examples

      # Deleting a player with a valid struct
      iex> delete_player(player)
      {:ok, %Player{id: 4, name: "Charlie", email: "charlie@example.com", score: 10}}

      # Attempting to delete a player that does not exist or has constraints preventing deletion
      iex> delete_player(non_existent_player)
      {:error, changeset}

  ## Returns

  - `{:ok, %Player{}}`: Successfully deleted player.
  - `{:error, changeset}`: The deletion failed due to a constraint or the player does not exist.

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end
end
