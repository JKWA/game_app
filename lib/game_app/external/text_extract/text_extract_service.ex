defmodule GameApp.External.TextExtractService do
  @moduledoc """
  This module serves as a service layer, delegating text extraction tasks
  to an implementation specified in the application's configuration and
  ensuring compliance with the `GameApp.External.TextExtractBehaviour`
  behaviour.

  ## Usage

  The module uses the application configuration to resolve which implementation
  to use for text extraction tasks.

  """

  @behaviour GameApp.External.TextExtractBehaviour

  @doc """
  Delegates the task of extracting text from a given URL to the configured text extraction implementation.

  ## Parameters

  - `url`: The URL from which to extract text.

  ## Returns

  - A tuple response from the text extraction implementation, typically `{:ok, text}` for successful extractions or `{:error, reason}` for failures.

  """
  def extract_text(url) do
    impl().extract_text(url)
  end

  defp impl do
    Application.get_env(:game_app, :text_extract_service)
  end
end
