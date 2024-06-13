defmodule GameApp.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :email, :string
    field :score, :integer, default: 0

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :email, :score])
    |> validate_required([:name, :email])
    |> validate_email()
    |> unique_constraint(:email)
    |> put_change_if_nil(:score, 0)
    |> validate_score_non_negative()
  end

  def update_changeset(player, attrs \\ %{}) do
    player
    |> cast(attrs, [:name, :score])
    |> validate_required([:name, :score])
    |> validate_score_not_decrease()
  end

  defp validate_email(changeset) do
    validate_format(changeset, :email, ~r/@/, message: "must contain @")
  end

  defp validate_score_non_negative(changeset) do
    validate_number(changeset, :score,
      greater_than_or_equal_to: 0,
      message: "Score must be non-negative."
    )
  end

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

  defp put_change_if_nil(changeset, field, value) do
    current_value = get_field(changeset, field)

    if current_value == nil do
      put_change(changeset, field, value)
    else
      changeset
    end
  end
end
