defmodule GameAppWeb.LongJobLive.Index do
  use GameAppWeb, :live_view
  alias GameApp.Workers.LongJobWorker
  alias Phoenix.PubSub
  import Ecto.UUID, only: [generate: 0]

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GameApp.PubSub, LongJobWorker.topic())

    new_socket =
      socket
      |> assign(:job_results, [])
      |> assign(:job_number, 0)
      |> assign(:parent_span_id, generate())

    {:ok, new_socket}
  end

  @impl true
  def handle_event("trigger_job", _params, socket) do
    job_number = socket.assigns.job_number + 1
    parent_span_id = socket.assigns.parent_span_id

    job_name = "Job #{job_number}"

    LongJobWorker.new(%{
      name: job_name,
      parent_span_id: parent_span_id
    })
    |> Oban.insert()
    |> case do
      {:ok, _job} ->
        new_socket =
          socket
          |> assign(:job_number, job_number)

        {:noreply, new_socket}

      {:error, _reason} ->
        new_socket =
          socket
          |> put_flash(:error, "Failed to trigger #{job_name}.")

        {:noreply, new_socket}
    end
  end

  @impl true
  def handle_info({:job_started, message}, socket) do
    new_socket =
      socket
      |> put_flash(:info, message)

    {:noreply, new_socket}
  end

  @impl true
  def handle_info({:job_completed, message}, socket) do
    new_socket =
      socket
      |> update(:job_results, fn results ->
        results ++ [message]
      end)
      |> put_flash(:info, message)

    {:noreply, new_socket}
  end

  @impl true
  def handle_info({:job_warning, message}, socket) do
    new_socket =
      socket
      |> update(:job_results, fn results ->
        results ++ [message]
      end)

    {:noreply, new_socket}
  end

  @impl true
  def handle_info({:job_failed, message}, socket) do
    new_socket =
      socket
      |> update(:job_results, fn results ->
        results ++ [message]
      end)
      |> put_flash(:error, message)

    {:noreply, new_socket}
  end
end
