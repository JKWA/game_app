defmodule GameApp.ModelCase do
  @moduledoc """
  Provides shared functionality and setup for schema-related tests within the GameApp.

  This module includes helper functions to facilitate the creation of valid and invalid parameters based on schema definitions, assertion of changeset properties, and more comprehensive schema checks.
  """
  alias Ecto.Adapters.SQL.Sandbox

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Changeset
      import GameApp.ModelCase
    end
  end

  setup _ do
    Sandbox.mode(GameApp.Repo, :manual)
  end

  @doc """
  Generates valid parameters based on provided field types.

  ## Parameters

    - `fields_with_types`: A list of field-type tuples.
    - `overrides`: A map of values to override default generated values.

  ## Returns

    - A map of valid parameters.
  """
  @spec valid_params([{atom(), any()}], map()) :: map()

  def valid_params(fields_with_types, overrides \\ %{}) do
    valid_value_by_type = %{
      id: fn -> Enum.random(1..1_000_000) end,
      date: fn -> to_string(Faker.Date.date_of_birth()) end,
      float: fn -> :rand.uniform() * 10 end,
      string: fn -> Faker.Lorem.word() end,
      binary_id: fn -> Ecto.UUID.generate() end,
      integer: fn -> Enum.random(-1000..1000) end,
      naive_datetime: fn -> NaiveDateTime.utc_now() end,
      boolean: fn -> Enum.random([true, false]) end
    }

    fields_with_types
    |> Enum.map(fn {field, type} ->
      generator_function = Map.get(valid_value_by_type, type)

      if is_nil(generator_function) do
        raise ArgumentError, "No generator function defined for type: #{inspect(type)}"
      end

      {Atom.to_string(field), generator_function.()}
    end)
    |> Enum.into(%{})
    |> Map.merge(overrides)
  end

  @doc """
  Generates invalid parameters based on provided field types.

  ## Parameters

    - `fields_with_types`: A list of field-type tuples.
    - `overrides`: A map of values to override default generated values.

  ## Returns

    - A map of invalid parameters.
  """
  @spec invalid_params([{atom(), any()}], map()) :: map()
  def invalid_params(fields_with_types, overrides \\ %{}) do
    invalid_value_by_type = %{
      id: fn -> Faker.Lorem.word() end,
      date: fn -> Faker.Lorem.word() end,
      float: fn -> Faker.Lorem.word() end,
      string: fn -> DateTime.utc_now() end,
      binary_id: fn -> 1 end,
      integer: fn -> Faker.Lorem.word() end,
      naive_datetime: fn -> Faker.Lorem.word() end,
      boolean: fn -> Faker.Lorem.word() end
    }

    fields_with_types
    |> Enum.map(fn {field, type} ->
      generator_function = Map.get(invalid_value_by_type, type)

      if is_nil(generator_function) do
        raise ArgumentError, "No generator function defined for type: #{inspect(type)}"
      end

      {Atom.to_string(field), generator_function.()}
    end)
    |> Enum.into(%{})
    |> Map.merge(overrides)
  end

  @doc """
  Asserts that the fields and their respective types in a schema module match the expected definitions.

  This function is essential for verifying that an Ecto schema module's fields and their types align with predetermined expectations. It is particularly useful in testing scenarios where schema accuracy is critical, such as ensuring compatibility with external systems or data integrity constraints.

  ## Parameters:
  - `schema_module`: The schema module whose fields and types are to be verified. This should be a module that includes Ecto.Schema with defined fields.
  - `expected_fields_with_types`: A list of tuples where each tuple contains a field (as an atom) and its expected type. This list defines what fields and their corresponding types should be present in the schema.

  ## Returns:
  - Returns the `schema_module` if the fields and types match the expected definitions, facilitating further processing or chaining of functions.

  Raises an `AssertionError` if the actual fields and types in the schema do not match the expected definitions, with a message detailing the discrepancies.

  """
  @spec assert_schema_fields_and_types(module(), [{atom(), any()}]) :: module()
  def assert_schema_fields_and_types(schema_module, expected_fields_with_types) do
    actual_fields_with_types =
      for field <- schema_module.__schema__(:fields) do
        type = schema_module.__schema__(:type, field)
        {field, type}
      end

    assert Enum.sort(actual_fields_with_types) ==
             Enum.sort(expected_fields_with_types),
           "Expected fields and types do not match the actual schema fields and types. " <>
             "Expected: #{inspect(Enum.sort(expected_fields_with_types))}, " <>
             "Got: #{inspect(Enum.sort(actual_fields_with_types))}"

    schema_module
  end

  @doc """
  Asserts that a given changeset contains all the expected errors for fields that are not listed as optional.

  This function checks that the `changeset` is invalid and that each required field has the appropriate error messages based on expected validations. If a field is part of the optional fields list, it is not checked for errors.

  ## Parameters:
  - `changeset`: The `Ecto.Changeset` to be validated.
  - `fields_with_types`: A list of tuples, where each tuple consists of a field (atom) and its associated type, indicating what error to expect.
  - `optional_fields`: A list of fields (atoms) that are optional and not required to contain errors.

  ## Returns:
  - The `changeset` if all non-optional fields contain the correct errors.

  Raises an `AssertionError` if the changeset is valid or if any non-optional fields do not contain the correct errors.

  """
  @spec assert_invalid_changeset_errors(Ecto.Changeset.t(), [{atom(), any()}], [atom()]) ::
          Ecto.Changeset.t()
  def assert_invalid_changeset_errors(changeset, fields_with_types, optional_fields) do
    assert %Ecto.Changeset{valid?: false, errors: errors} = changeset

    error_messages =
      Enum.reduce(fields_with_types, [], fn {field, _}, acc ->
        if field in optional_fields do
          acc
        else
          acc ++ generate_error_message(field, errors[field])
        end
      end)

    assert error_messages == [],
           "Errors encountered:\n" <> Enum.join(error_messages, "\n")

    changeset
  end

  defp generate_error_message(field, nil), do: ["The field :#{field} is missing from errors."]

  defp generate_error_message(field, {_, meta}) do
    case meta[:validation] do
      :cast ->
        []

      _ ->
        [
          "The validation type for field :#{field} is incorrect. Expected: :cast, got: #{meta[:validation]}"
        ]
    end
  end

  @doc """
  Checks if the changes in a changeset match the expected attributes, excluding specified fields.

  ## Parameters

    - `changeset`: The Ecto.Changeset to be checked.
    - `attrs`: A map of attributes with expected values.
    - `fields_with_types`: A list of tuples, each containing a field name as an atom and its type.
    - `excluded_fields`: (Optional) A list of field names to be excluded from checking.

  ## Returns

  Returns the changeset.
  """
  @spec assert_changes_correct(Ecto.Changeset.t(), map(), [{atom(), any()}], [atom()]) ::
          Ecto.Changeset.t()
  def assert_changes_correct(changeset, attrs, fields_with_types, excluded_fields \\ []) do
    for {field, _} <- fields_with_types, field not in excluded_fields do
      actual = Map.get(changeset.changes, field)
      expected = attrs[Atom.to_string(field)]

      assert actual == expected,
             "Values did not match for field: #{field}\nexpected: #{inspect(expected)}\nactual: #{inspect(actual)}"
    end

    changeset
  end

  @doc """
  Asserts that specific fields in a given changeset contain errors, ensuring that expected validations fail as anticipated.

  This function iterates over a list of field names and verifies that each specified field has at least one associated error in the changeset. It is used to confirm that the changeset does not pass validations that should indeed fail, such as checking for required fields, specific value constraints, or other validation rules.

  ## Parameters:
  - `changeset`: The `Ecto.Changeset` to be inspected for errors.
  - `fields`: A list of fields (atoms) that are expected to have errors in the changeset.

  ## Returns:
  - The `changeset` if all specified fields contain errors, facilitating further assertions or operations on it.

  Raises an `AssertionError` if any of the specified fields do not contain errors, with a message indicating the field lacking the expected error.

  """

  @spec assert_has_errors(Ecto.Changeset.t(), [atom()]) :: Ecto.Changeset.t()
  def assert_has_errors(changeset, fields) do
    Enum.each(fields, fn field ->
      assert Enum.any?(changeset.errors, fn
               {field_key, _} -> field_key == field
               _ -> false
             end),
             "Expected error for field #{inspect(field)} but none found"
    end)

    changeset
  end
end
