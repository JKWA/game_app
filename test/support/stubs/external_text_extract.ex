defmodule GameApp.Stubs.TextExtractService do
  @moduledoc """
  Provides a stub implementation of the `GameApp.External.TextExtractBehaviour`
  for testing purposes.
  """

  @behaviour GameApp.External.TextExtractBehaviour

  @error_url "https://www.error_url.com"

  require Faker

  @doc """
  Simulates the extraction of text from a URL.

  ## Parameters

  - `url`: The URL from which text is to be extracted.

  ## Returns

  - `{:ok, text}` when the URL does not match the `@error_url`.
  - `{:error, "Failed to extract text"}` when the URL matches the `@error_url`.

  """
  def extract_text(@error_url), do: {:error, "Failed to extract text"}

  def extract_text(_url) do
    paragraphs = Faker.Lorem.paragraphs(3)
    text = Enum.join(paragraphs, "\n\n")
    {:ok, text}
  end

  @doc """
  Retrieves the predefined error URL that triggers an error response when used with `extract_text/1`.
  """
  def get_error_url(), do: @error_url
end
