defmodule GameApp.SuperheroesTest do
  @moduledoc """
  Tests for the Superheroes module.
  """
  use GameApp.DataCase

  alias GameApp.Superheroes
  alias GameApp.Superheroes.Superhero

  @moduletag :superhero
  @moduletag :database

  setup do
    superhero = insert(:superhero)
    {:ok, superhero: superhero}
  end

  describe "superhero" do
    test "list_superhero/0 returns all superheroes", %{superhero: superhero} do
      assert Superheroes.list_superhero() == [superhero]
    end

    test "get_superhero!/1 returns the superhero with given id", %{superhero: superhero} do
      assert Superheroes.get_superhero!(superhero.id) == superhero
    end

    test "create_superhero/1 with valid data creates a superhero" do
      valid_attrs = %{
        name: Faker.Superhero.name(),
        location: Faker.Address.city(),
        power: Faker.random_between(1, 100)
      }

      assert {:ok, %Superhero{} = superhero} = Superheroes.create_superhero(valid_attrs)
      assert superhero.name == valid_attrs.name
      assert superhero.location == valid_attrs.location
      assert superhero.power == valid_attrs.power
    end

    test "update_superhero/2 with valid data updates the superhero", %{superhero: superhero} do
      update_attrs = %{
        name: Faker.Superhero.name(),
        location: Faker.Address.city(),
        power: Faker.random_between(1, 100)
      }

      assert {:ok, %Superhero{} = superhero} =
               Superheroes.update_superhero(superhero, update_attrs)

      assert superhero.name == update_attrs.name
      assert superhero.location == update_attrs.location
      assert superhero.power == update_attrs.power
    end

    test "delete_superhero/1 deletes the superhero", %{superhero: superhero} do
      assert {:ok, %Superhero{}} = Superheroes.delete_superhero(superhero)
      assert_raise Ecto.NoResultsError, fn -> Superheroes.get_superhero!(superhero.id) end
    end
  end
end
