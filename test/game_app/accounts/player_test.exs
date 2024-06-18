defmodule GameApp.Accounts.PlayerTest do
  @moduledoc """
  Provides tests for the Player entity within the GameApp.Accounts context.

  This module contains tests for validating the schema definitions and changeset functions.
  """
  use GameApp.ModelCase

  alias GameApp.Accounts.Player

  @moduletag :player

  @expected_fields_with_types [
    {:id, :id},
    {:name, :string},
    {:email, :string},
    {:score, :integer},
    {:inserted_at, :naive_datetime},
    {:updated_at, :naive_datetime}
  ]

  @excluded [:id, :inserted_at, :updated_at]

  describe "player schema" do
    @tag :schema

    test "has the correct fields and types" do
      assert_schema_fields_and_types(Player, @expected_fields_with_types)
    end
  end

  describe "create_changeset/1" do
    @tag :changeset

    test "success: returns a valid changeset when given valid arguments" do
      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("email", Faker.Internet.email())
        |> Map.put("score", Faker.random_between(0, 100_000))

      changeset = Player.create_changeset(attrs)

      assert changeset.valid?, "Expected changeset to be valid"

      assert_changes_correct(changeset, attrs, @expected_fields_with_types, @excluded)
    end

    test "failure: cannot cast invalid values" do
      attrs = invalid_params(@expected_fields_with_types)

      changeset = Player.create_changeset(attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to uncastable values"
      assert_invalid_changeset_errors(changeset, @expected_fields_with_types, @excluded)
    end

    test "failure: score cannot be negative" do
      negative_score = Faker.random_between(-100_000, -1)

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("email", Faker.Internet.email())
        |> Map.put("score", negative_score)

      changeset = Player.create_changeset(attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to negative score"

      assert_has_errors(changeset, [:score])
    end

    test "failure: email must include an '@' sign" do
      invalid_emiail = Faker.Lorem.word()

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("email", invalid_emiail)
        |> Map.put("score", Faker.random_between(0, 100_000))

      changeset = Player.create_changeset(attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to incorrect email format"

      assert_has_errors(changeset, [:email])
    end

    test "success: missing score is valid" do
      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("email", Faker.Internet.email())
        |> Map.delete("score")

      changeset = Player.create_changeset(attrs)

      assert changeset.valid?, "Expected changeset to be valid despite missing score"

      assert_changes_correct(changeset, attrs, @expected_fields_with_types, @excluded)
    end
  end

  describe "update_changeset/2" do
    @tag :changeset
    setup do
      player = %Player{name: Faker.Person.name(), email: Faker.Internet.email(), score: 10}
      {:ok, player: player}
    end

    test "success: returns a valid changeset when given valid arguments", %{player: player} do
      increment_score = player.score + 10

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("name", Faker.Person.name())
        |> Map.put("score", increment_score)

      changeset = Player.update_changeset(player, attrs)

      assert changeset.valid?, "Expected changeset to be valid"

      assert_changes_correct(changeset, attrs, @expected_fields_with_types, @excluded ++ [:email])
    end

    test "failure: cannot cast invalid values", %{player: player} do
      attrs = invalid_params(@expected_fields_with_types)

      changeset = Player.update_changeset(player, attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to uncastable values"

      assert_invalid_changeset_errors(
        changeset,
        @expected_fields_with_types,
        @excluded ++ [:email]
      )
    end

    test "failure: cannot decrement a score", %{player: player} do
      decrement_score = player.score - 1

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("score", decrement_score)

      changeset = Player.update_changeset(player, attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to score decrement"

      assert_has_errors(changeset, [:score])
    end
  end
end
