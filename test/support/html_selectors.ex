defmodule GameAppWeb.HTMLSelectors do
  import Phoenix.LiveViewTest

  @doc """
  Constructs a CSS selector for finding error messages related to a specific form field.

  ## Parameters

  - `form_group_atom`: The atom representing the form group prefix.
  - `field_name`: The binary string name of the field.
  - `input_type_atom`: The atom representing the HTML input type.

  ## Returns

  - A binary string that represents the CSS selector for the specified error message element.

  ## Examples

      iex> GameAppWeb.HTMLSelectors.select_error_message(:user, "email", :input)
      "[phx-feedback-for='user[email]'] input[name='user[email]'] + p"
  """
  @spec select_error_message(atom(), String.t(), atom()) :: String.t()
  def select_error_message(form_group_atom, field_name, input_type_atom)
      when is_atom(form_group_atom) and is_binary(field_name) and is_atom(input_type_atom) do
    form_group = Atom.to_string(form_group_atom)
    input_type = Atom.to_string(input_type_atom)

    "[phx-feedback-for='#{form_group}[#{field_name}]'] #{input_type}[name='#{form_group}[#{field_name}]'] + p"
  end

  @doc """
  Checks if an error message is present for a specific form field or multiple fields in a LiveView, supporting overloads for different use cases.

  ## Overloads

  1. `has_error_message?(live_view, form_group_atom, field_name)`

     Checks for an error message associated with a single form field, assuming the input type is `:input` by default.

  2. `has_error_message?(live_view, form_group_atom, opts)`

     Checks for error messages associated with multiple form fields, where `opts` is a list of tuples specifying the input type and field name.

  ## Parameters

  - `live_view`: The `Phoenix.LiveViewTest.LiveView` under test.
  - `form_group_atom`: The atom representing the form group prefix.
  - `field_name`: (For the first overload) The binary string name of the field.
  - `opts`: (For the second overload) A list of tuples, each containing an atom for the input type and a binary string for the field name.

  ## Returns

  - `true` if the error message(s) are present for the specified field(s); otherwise, `false`.

  ## Examples

  ### Single Field Check

  Assuming you want to check for an error message on the "email" field within a "user" form group:

      iex> GameAppWeb.HTMLSelectors.has_error_message?(live_view, :user, "email")
      true

  """
  @spec has_error_message?(Phoenix.LiveViewTest.View.t(), atom(), String.t()) :: boolean()
  def has_error_message?(live_view, form_group_atom, field_name)
      when is_atom(form_group_atom) and is_binary(field_name) do
    has_element?(
      live_view,
      select_error_message(form_group_atom, field_name, :input)
    )
  end

  @doc """
  Constructs a CSS selector for finding flash messages of a specific kind.

  ## Parameters

  - `kind`: The atom representing the kind of flash message (e.g., :error, :info).

  ## Returns

  - A binary string that represents the CSS selector for the specified flash message.

  ## Examples

      iex> GameAppWeb.HTMLSelectors.select_flash_message(:info)
      "[role='alert'][data-kind='info']"
  """
  @spec select_flash_message(atom()) :: String.t()
  def select_flash_message(kind) when is_atom(kind) do
    "[role='alert'][data-kind='#{Atom.to_string(kind)}']"
  end

  @doc """
  Checks for the presence of a flash message of a specific kind and, optionally, verifies its content.

  ## Overloads

  1. `has_flash?(%{flash: flash}, kind)`

     Checks for a flash message within a given map of flash messages without verifying its content.

  2. `has_flash?(live_view, kind)`

     Checks for a flash message within the rendered HTML of a LiveView without verifying its content.

  3. `has_flash?(conn_or_flash_map, kind, expected_text)`

     Checks for a flash message within a given connection struct or map of flash messages, verifying that it contains the expected text.

  ## Parameters

  - `conn_or_flash_map`: The connection struct or a map containing flash messages.
  - `live_view`: The `Phoenix.LiveViewTest.LiveView` under test for checking rendered HTML.
  - `kind`: The atom representing the kind of flash message (e.g., :error, :info).
  - `expected_text`: (For the third overload) The expected text content within the flash message.

  ## Returns

  - `true` if the flash message of the specified kind is present and, when applicable, matches the expected content; otherwise, `false`.

  ## Examples

  ### Verifying Flash Message Content After Navigation

      test "failure: edit redirects deleted invitation", %{conn: conn, deleted_invitation: invitation} do
        assert {:error, {:redirect, to}} = live(conn, get_url(invitation.id))
        assert has_flash?(to, :error, "not found")
      end
  """
  @spec has_flash?(%{flash: map()}, atom()) :: boolean()
  def has_flash?(%{flash: flash}, kind) when is_map(flash) and is_atom(kind) do
    Map.has_key?(flash, Atom.to_string(kind))
  end

  @spec has_flash?(Phoenix.LiveViewTest.LiveView, atom()) :: boolean()
  def has_flash?(live_view, kind) when is_atom(kind) do
    has_element?(live_view, select_flash_message(kind))
  end

  @spec has_flash?(Phoenix.LiveViewTest.Conn.t() | map(), atom(), String.t()) :: boolean()
  def has_flash?(%{flash: flash}, kind, expected_text)
      when is_map(flash) and is_atom(kind) and is_binary(expected_text) do
    flash
    |> Map.get(Atom.to_string(kind))
    |> check_flash_text(expected_text)
  end

  defp check_flash_text(nil, _expected_text), do: false

  defp check_flash_text(actual_text, expected_text)
       when is_binary(actual_text) and is_binary(expected_text) do
    actual_text
    |> String.downcase()
    |> String.contains?(String.downcase(expected_text))
  end

  defp check_flash_text(_actual_text, _expected_text), do: false
end
