defmodule GameApp.External.TextExtractDevService do
  @moduledoc """
  Implements `GameApp.External.TextExtractBehaviour` for handling text extraction
  """
  @base_url "http://localhost:8201/"
  @behaviour GameApp.External.TextExtractBehaviour

  @doc """
  Extract text from a file by sending it to the external FastAPI service.
  """
  def extract_text(url) do
    path = "get-text/"

    query = URI.encode_query(%{"url" => url})

    url = "#{@base_url}#{path}?#{query}"

    headers = [{"accept", "text/plain"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch text, status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end
end
