defmodule GameApp.Superheroes do
  @moduledoc """
  The Superheroes context.
  """

  import Ecto.Query, warn: false
  alias GameApp.Repo

  alias GameApp.Superheroes.Superhero

  @doc """
  Returns the list of superhero.

  ## Examples

      iex> list_superhero()
      [%Superhero{}, ...]

  """
  def list_superhero do
    Repo.all(Superhero)
  end

  @doc """
  Gets a single superhero.

  Raises `Ecto.NoResultsError` if the Superhero does not exist.

  ## Examples

      iex> get_superhero!(123)
      %Superhero{}

      iex> get_superhero!(456)
      ** (Ecto.NoResultsError)

  """
  def get_superhero!(id), do: Repo.get!(Superhero, id)

  @doc """
  Creates a superhero.

  ## Examples

      iex> create_superhero(%{field: value})
      {:ok, %Superhero{}}

      iex> create_superhero(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_superhero(attrs \\ %{}) do
    %Superhero{}
    |> Superhero.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a superhero.

  ## Examples

      iex> update_superhero(superhero, %{field: new_value})
      {:ok, %Superhero{}}

      iex> update_superhero(superhero, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_superhero(%Superhero{} = superhero, attrs) do
    superhero
    |> Superhero.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a superhero.

  ## Examples

      iex> delete_superhero(superhero)
      {:ok, %Superhero{}}

      iex> delete_superhero(superhero)
      {:error, %Ecto.Changeset{}}

  """
  def delete_superhero(%Superhero{} = superhero) do
    Repo.delete(superhero)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking superhero changes.

  ## Examples

      iex> change_superhero(superhero)
      %Ecto.Changeset{data: %Superhero{}}

  """
  def change_superhero(%Superhero{} = superhero, attrs \\ %{}) do
    Superhero.changeset(superhero, attrs)
  end

  alias GameApp.Superheroes.Superhero

  @doc """
  Returns the list of superheroes.

  ## Examples

      iex> list_superheroes()
      [%Superhero{}, ...]

  """
  def list_superheroes do
    Repo.all(Superhero)
  end
end
