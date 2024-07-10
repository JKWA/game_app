defmodule GameApp.Workers.LongJobWorker do
  @moduledoc """
  A worker module for handling long-running jobs using Oban.

  This module defines a worker that processes jobs from the `:long_jobs` queue.
  Each job performs a simulated long-running task by sleeping for a random
  amount of time between 1,000 and 10,000 milliseconds.
  """
  require Logger
  use Oban.Worker, queue: :long_jobs, max_attempts: 3

  @long_job_topic "long_job"

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
  @impl Oban.Worker
  def perform(%Oban.Job{
        id: trace_id,
        args: args,
        attempt: attempt,
        queue: queue,
        max_attempts: max_attempts,
        worker: worker
      }) do
    job_name = Map.get(args, "name", "Default Name")
    parent_span_id = Map.get(args, "parent_span_id", nil)

    if parent_span_id do
      Logger.metadata(parent_span_id: parent_span_id)
    end

    start_time = System.system_time(:millisecond)

    broadcast_update(:job_started, "#{job_name} job started")

    random_sleep_ms = :rand.uniform(9_000) + 1_000
    Process.sleep(random_sleep_ms)
    end_time = System.system_time(:millisecond)

    # Fails 1 out of 3 times
    should_fail = :rand.uniform(3) == 1

    status =
      if should_fail do
        "failed"
      else
        "completed"
      end

    Logger.metadata(
      trace_id: trace_id,
      span_id: "#{trace_id}-#{attempt}",
      parent_span_id: parent_span_id,
      start_time: start_time,
      end_time: end_time,
      job_name: job_name,
      worker: worker,
      status: status,
      queue: queue,
      attempt: attempt,
      max_attempts: max_attempts
    )

    if should_fail do
      if attempt < max_attempts do
        warning_message = "#{job_name} job failed on attempt #{attempt}. Retrying..."
        Logger.metadata(status: "retrying")
        Logger.warning(warning_message)

        broadcast_update(:job_warning, warning_message)
      else
        failed_message = "#{job_name} job failed on final attempt #{attempt}"
        Logger.error(failed_message)
        broadcast_update(:job_failed, failed_message)
      end

      Logger.metadata([])
      {:error, "Job failed"}
    else
      complete_message = "#{job_name} completed after #{random_sleep_ms} ms"
      Logger.info(complete_message)
      broadcast_update(:job_completed, complete_message)
      Logger.metadata([])
      :ok
    end
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
