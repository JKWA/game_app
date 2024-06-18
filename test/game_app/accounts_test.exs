defmodule GameApp.AccountsTest do
  use GameApp.DataCase

  alias GameApp.Accounts
  alias GameApp.Accounts.Player

  @moduletag :accounts
  @moduletag :player
  @moduletag :database

  setup do
    player = insert(:player)
    {:ok, player: player}
  end

  describe "list_players/0" do
    test "lists all players", %{player: player} do
      assert Accounts.list_players() == [player]
    end
  end

  describe "get_player/1" do
    test "retrieves a player by id", %{player: player} do
      assert {:ok, retrieved_player} = Accounts.get_player(player.id)
      assert_player_attributes(player, retrieved_player)
    end

    test "returns :none when player does not exist" do
      assert {:none} = Accounts.get_player(-1)
    end
  end

  describe "create_player/1" do
    setup do
      attrs = %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        score: Faker.random_between(1, 100_000)
      }

      {:ok, attrs: attrs}
    end

    test "creates a new player", %{attrs: attrs} do
      assert {:ok, new_player} = Accounts.create_player(attrs)
      assert_player_attributes(attrs, new_player)
    end

    test "creates a player with default score when score is not provided", %{attrs: attrs} do
      attrs = Map.delete(attrs, :score)
      assert {:ok, new_player} = Accounts.create_player(attrs)
      default_score = Player.default_score()
      assert new_player.score == default_score
    end

    test "fails to create a player with negative score", %{attrs: attrs} do
      attrs = Map.put(attrs, :score, -1)
      assert {:error, _} = Accounts.create_player(attrs)
    end

    test "fails to create a player with invalid email", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "invalid")
      assert {:error, _} = Accounts.create_player(attrs)
    end

    test "fails to create a player with an existing email", %{player: player, attrs: attrs} do
      attrs = Map.put(attrs, :email, player.email)
      assert {:error, _} = Accounts.create_player(attrs)
    end
  end

  describe "update_player/2" do
    test "updates a player successfully", %{player: player} do
      update_attrs = %{name: Faker.Person.name(), score: player.score + 1}
      assert {:ok, updated_player} = Accounts.update_player(player, update_attrs)
      assert updated_player.name == update_attrs.name
      assert updated_player.score == update_attrs.score
    end

    test "fails to decrement player score", %{player: player} do
      update_attrs = %{score: player.score - 1}
      assert {:error, _} = Accounts.update_player(player, update_attrs)
    end

    test "does not change email on update", %{player: player} do
      update_attrs = %{email: Faker.Internet.email()}
      assert {:ok, updated_player} = Accounts.update_player(player, update_attrs)
      refute updated_player.email == update_attrs.email
    end
  end

  describe "delete_player/1" do
    test "deletes a player", %{player: player} do
      id = player.id
      assert {:ok, _} = Accounts.get_player(id)
      assert {:ok, _} = Accounts.delete_player(player)
      assert {:none} = Accounts.get_player(id)
    end
  end

  defp assert_player_attributes(expected, actual) do
    assert actual.name == expected.name
    assert actual.email == expected.email
    assert actual.score == expected.score
  end
end
