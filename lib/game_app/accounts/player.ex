defmodule GameApp.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Provides the schema and changesets for player accounts within the `GameApp`.
  """

  @typedoc """
  Type representing the player struct with fields id, name, email, score, inserted_at, and updated_at.
  """
  @doc """
  Defines the Ecto schema for the `players` table in the database.

  ## Schema fields
  - `:name` - The player's name (String).
  - `:email` - The player's email address (String).
  - `:score` - The player's game score (Integer), defaults to 0.
  - `timestamps` - Automatically managed fields for created_at and updated_at.
  """

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          email: String.t(),
          score: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  schema "players" do
    field :name, :string
    field :email, :string
    field :score, :integer, default: 0

    timestamps()
  end

  @doc """
  Creates a changeset for a new player with validations for required fields, email format, and score.

  ## Parameters
  - `attrs`: Map of attributes for the new player.

  ## Returns
  - A `Ecto.Changeset` struct ready for insertion.
  """
  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :email, :score])
    |> validate_required([:name, :email])
    |> validate_email()
    |> unique_constraint(:email)
    |> put_change_if_nil(:score, 0)
    |> validate_score_non_negative()
  end

  @doc """
  Creates a changeset for updating an existing player with validations for score not decreasing.

  ## Parameters
  - `player`: The existing player record.
  - `attrs`: (Optional) Map of attributes to update.

  ## Returns
  - A `Ecto.Changeset` struct ready for updating.
  """
  @spec update_changeset(t(), map()) :: Ecto.Changeset.t()
  def update_changeset(player, attrs \\ %{}) do
    player
    |> cast(attrs, [:name, :score])
    |> validate_required([:name, :score])
    |> validate_score_not_decrease()
  end

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email(changeset) do
    validate_format(changeset, :email, ~r/@/, message: "must contain @")
  end

  @spec validate_score_non_negative(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_score_non_negative(changeset) do
    validate_number(changeset, :score,
      greater_than_or_equal_to: 0,
      message: "Score must be non-negative."
    )
  end

  @spec validate_score_not_decrease(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_score_not_decrease(changeset) do
    original_score = changeset.data.score
    update_score = get_change(changeset, :score, original_score)

    case {original_score, update_score} do
      {nil, _update_score} ->
        changeset

      {_current_score, nil} ->
        changeset

      {original, update} when update < original ->
        add_error(changeset, :score, "Score cannot decrease.")

      _ ->
        changeset
    end
  end

  @spec put_change_if_nil(Ecto.Changeset.t(), atom(), any()) :: Ecto.Changeset.t()
  defp put_change_if_nil(changeset, field, value) do
    current_value = get_field(changeset, field)

    if current_value == nil do
      put_change(changeset, field, value)
    else
      changeset
    end
  end
end
