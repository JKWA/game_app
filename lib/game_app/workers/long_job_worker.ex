defmodule GameApp.Workers.LongJobWorker do
  @moduledoc """
  A worker module for handling long-running jobs using Oban.

  This module defines a worker that processes jobs from the `:long_jobs` queue.
  Each job performs a simulated long-running task by sleeping for a random
  amount of time between 1,000 and 10,000 milliseconds.
  """

  use Oban.Worker, queue: :long_jobs, max_attempts: 3

  @long_job_topic "long_job"

  @impl true
  @doc """
  Executes the job.

  This function is called by Oban when a job is processed. It simulates a long-running
  task by sleeping for a random amount of time and then broadcasts the start and completion
  of the job.

  ## Parameters
    - job: An `Oban.Job` struct containing the job arguments.

  ## Returns
    - :ok
  """
  @spec perform(Oban.Job.t()) :: :ok
  def perform(%Oban.Job{args: args}) do
    name = Map.get(args, "name", "Default Name")

    broadcast_update(
      :job_started,
      "#{name} job started"
    )

    random_sleep_ms = :rand.uniform(9_000) + 1_000
    Process.sleep(random_sleep_ms)

    broadcast_update(
      :job_completed,
      "#{name} completed after #{random_sleep_ms} ms"
    )

    :ok
  end

  @doc """
  Returns the topic for broadcasting job updates.

  ## Returns
    - The topic as a string.
  """
  @spec topic() :: String.t()
  def topic do
    @long_job_topic
  end

  @doc false
  @spec broadcast_update(atom(), String.t()) :: :ok
  defp broadcast_update(action, message) do
    Phoenix.PubSub.broadcast(
      GameApp.PubSub,
      @long_job_topic,
      {action, message}
    )
  end
end
