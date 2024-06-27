defmodule GameApp.Websites.GetText do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Defines the Ecto schema and changeset validations for `get_text`.
  """

  @type t :: %__MODULE__{
          url: String.t()
        }

  schema "get_text" do
    field :url, :string
  end

  @doc """
  Creates a changeset with URL validation for a given attribute map.

  ## Parameters

  - `attrs`: A map containing the URL data to be validated.

  ## Returns

  - An `Ecto.Changeset.t()` that can be used to validate and persist data to the database.
  """
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> validate_url(:url)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      case Regex.match?(~r/^https?:\/\/[^\s$.?#].[^\s]*$/, value) do
        true -> []
        false -> [{field, "is not a valid URL"}]
      end
    end)
  end
end
