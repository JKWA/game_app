defmodule GameApp.Superheroes.SuperheroTest do
  @moduledoc """
  Provides tests for the Superhero entity within the GameApp.Accounts context.

  This module contains tests for validating the schema definitions and changeset functions.
  """
  use GameApp.ModelCase

  alias GameApp.Superheroes.Superhero

  @moduletag :superhero
  @moduletag :schema

  @expected_fields_with_types [
    {:id, :id},
    {:name, :string},
    {:location, :string},
    {:power, :integer},
    {:inserted_at, :naive_datetime},
    {:updated_at, :naive_datetime}
  ]

  @excluded [:id, :inserted_at, :updated_at]

  describe "superhero schema" do
    @tag :schema

    test "has the correct fields and types" do
      assert_schema_fields_and_types(Superhero, @expected_fields_with_types)
    end
  end

  describe "changeset/1" do
    @tag :changeset

    test "success: returns a valid changeset when given valid arguments" do
      positive_score = Faker.random_between(1, 100)

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("power", positive_score)

      changeset = Superhero.changeset(%Superhero{}, attrs)
      assert changeset.valid?, "Expected changeset to be valid"

      assert_changes_correct(changeset, attrs, @expected_fields_with_types, @excluded)
    end

    test "failure: cannot cast invalid values" do
      attrs = invalid_params(@expected_fields_with_types)

      changeset = Superhero.changeset(%Superhero{}, attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to uncastable values"
      assert_invalid_changeset_errors(changeset, @expected_fields_with_types, @excluded)
    end

    test "failure: power cannot be negative" do
      negative_score = Faker.random_between(-100_000, -1)

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("power", negative_score)

      changeset = Superhero.changeset(%Superhero{}, attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to negative power"

      assert_has_errors(changeset, [:power])
    end
  end
end
