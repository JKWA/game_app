defmodule GameApp.External.TextExtractBehaviour do
  @moduledoc """
  The GameApp.External.TextExtractBehaviour defines a required
  contract for modules handling text extraction in the GameApp
  system.
  """

  @callback extract_text(url :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}
end
