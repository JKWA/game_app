defmodule GameAppWeb.IncrementLive.Index do
  use GameAppWeb, :live_view
  alias GameApp.Workers.IncrementWorker

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(:increment_value, 0)

    {:ok, new_socket}
  end

  @impl true
  def handle_event("increment_click", _params, socket) do
    new_value =
      socket.assigns.increment_value
      |> IncrementWorker.sync()

    new_socket =
      socket
      |> assign(:increment_value, new_value)

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("async_increment_click", _params, socket) do
    new_value =
      socket.assigns.increment_value
      |> IncrementWorker.async()
      |> Task.await()

    new_socket =
      socket
      |> assign(:increment_value, new_value)

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("real_async_increment_click", _params, socket) do
    socket.assigns.increment_value
    |> IncrementWorker.async()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({_pid, message}, socket) do
    new_socket =
      socket
      |> assign(:increment_value, message)
      |> put_flash(:info, "Increment success.")

    {:noreply, new_socket}
  end
end
