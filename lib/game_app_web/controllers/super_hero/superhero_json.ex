defmodule GameAppWeb.SuperheroJSON do
  alias GameApp.Superheroes.Superhero

  @doc """
  Renders a list of superheroes.
  """
  def index(%{superheroes: superheroes}) do
    %{data: for(superhero <- superheroes, do: data(superhero))}
  end

  @doc """
  Renders a single superhero.
  """
  def show(%{superhero: superhero}) do
    %{data: data(superhero)}
  end

  defp data(%Superhero{} = superhero) do
    %{
      id: superhero.id,
      name: superhero.name,
      location: superhero.location,
      power: superhero.power
    }
  end
end
