defmodule GameApp.Superheroes.Superhero do
  @moduledoc """
  The schema for the Superhero resource.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "superheroes" do
    field :name, :string
    field :location, :string
    field :power, :integer

    timestamps()
  end

  @doc false
  def changeset(superhero, attrs) do
    superhero
    |> cast(attrs, [:name, :location, :power])
    |> validate_required([:name, :location, :power])
    |> validate_number(:power, greater_than: 0, less_than_or_equal_to: 100)
  end
end
