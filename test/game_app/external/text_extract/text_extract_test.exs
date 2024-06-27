defmodule GameApp.External.TextExtractTest do
  @moduledoc """
  Provides tests for the GetText entity within the GameApp.Accounts context.

  This module contains tests for validating the schema definitions and changeset functions.
  """
  use GameApp.ModelCase

  alias GameApp.Websites.GetText

  @moduletag :text_extract

  @expected_fields_with_types [
    {:id, :id},
    {:url, :string}
  ]

  @excluded [:id]

  describe "text extract schema" do
    @tag :schema

    test "has the correct fields and types" do
      assert_schema_fields_and_types(GetText, @expected_fields_with_types)
    end
  end

  describe "create_changeset/1" do
    @tag :changeset

    test "success: returns a valid changeset when given valid arguments" do
      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("url", Faker.Internet.url())

      changeset = GetText.create_changeset(attrs)

      assert changeset.valid?, "Expected changeset to be valid"

      assert_changes_correct(changeset, attrs, @expected_fields_with_types, @excluded)
    end

    test "error: cannot cast invalid values" do
      attrs =
        invalid_params(@expected_fields_with_types)

      changeset = GetText.create_changeset(attrs)

      refute changeset.valid?, "Expected changeset to be valid"

      assert_invalid_changeset_errors(changeset, @expected_fields_with_types, @excluded)
    end

    test "failure: url must be valid" do
      invalid_url = Faker.Lorem.word()

      attrs =
        valid_params(@expected_fields_with_types)
        |> Map.put("url", invalid_url)

      changeset = GetText.create_changeset(attrs)

      refute changeset.valid?, "Expected changeset to be invalid due to invalid url"

      assert_has_errors(changeset, [:url])
    end
  end
end
