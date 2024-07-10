defmodule GameApp.LoggerFormatter do
  @moduledoc """
  A custom log formatter for `Logger`.
  """

  @common_metadata [
    :request_id,
    :job_id,
    :job_name,
    :worker,
    :attempt,
    :max_attempts,
    :queue,
    :status,
    :duration
  ]

  @doc """
  Returns the common metadata keys that are included in every log entry.
  """
  @spec common_metadata() :: [atom()]
  def common_metadata do
    @common_metadata
  end

  @doc """
  Formats a log entry.

  Takes a log `level`, `message`, `timestamp`, and `metadata`, and returns a single string line that represents
  the formatted log entry. This format is particularly suitable for log aggregation tools that are optimized
  for key-value based log messages.

  ## Parameters

  - `level`: The log level (e.g., `:info`, `:debug`, `:error`).
  - `message`: The log message.
  - `timestamp`: A tuple representing the timestamp of the log entry in the format `{{year, month, day}, {hour, minute, second, millisecond}}`.
  - `metadata`: A keyword list of metadata associated with the log entry.

  ## Returns

  A string that represents the log message formatted as a series of key-value pairs, terminated with a newline.

  """
  @spec format(
          level :: Logger.level(),
          message :: Logger.message(),
          timestamp :: {{integer, integer, integer}, {integer, integer, integer, integer}},
          metadata :: keyword()
        ) :: IO.chardata()
  def format(level, message, timestamp, metadata) do
    formatted_metadata =
      metadata
      |> Enum.into(%{})
      |> Map.put(:level, level)
      |> Map.put(:message, to_string(message))
      |> Map.put(:timestamp, format_timestamp(timestamp))
      |> Enum.map_join(" ", fn {key, value} -> "#{key}=#{inspect(value)}" end)

    "#{formatted_metadata}\n"
  end

  defp format_timestamp({{year, month, day}, {hour, minute, second, millisecond}}) do
    with {:ok, naive_datetime} <-
           NaiveDateTime.new(year, month, day, hour, minute, second, {millisecond, 3}),
         {:ok, utc_datetime} <- DateTime.from_naive(naive_datetime, "Etc/UTC") do
      DateTime.to_iso8601(utc_datetime)
    else
      _error -> "Invalid timestamp"
    end
  end
end
