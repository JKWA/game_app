defmodule GameAppWeb.NotificationsChannel do
  use GameAppWeb, :channel
  require Logger
  alias GameAppWeb.SuperheroPresence
  alias Faker.Superhero
  alias Phoenix.PubSub
  alias GameApp.Services.NotificationsService

  @impl true
  def join("notifications:lobby", _payload, socket) do
    user_name = Superhero.name()
    socket = assign(socket, :user_name, user_name)

    Logger.info("User #{user_name} joined the lobby")

    PubSub.subscribe(GameApp.PubSub, NotificationsService.topic(user_name))

    SuperheroPresence.track(socket, user_name, %{
      online_at: inspect(System.system_time(:second)),
      user_name: user_name
    })

    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    push(socket, "user_info", %{user_name: socket.assigns.user_name})
    presence_state = SuperheroPresence.list(socket)
    push(socket, "presence_state", presence_state)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "notification", payload: payload}, socket) do
    push(socket, "notification", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("notify_others", %{"body" => body}, socket) do
    timestamp = System.system_time(:second)

    broadcast_from(socket, "notification", %{
      "body" => body,
      "timestamp" => timestamp
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("notify_all", %{"body" => body}, socket) do
    timestamp = System.system_time(:second)

    broadcast(socket, "notification", %{
      "body" => body,
      "timestamp" => timestamp
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("notify_direct", %{"body" => body, "recipient" => recipient}, socket) do
    timestamp = System.system_time(:second)

    PubSub.broadcast(GameApp.PubSub, NotificationsService.topic(recipient), %{
      event: "notification",
      payload: %{
        "body" => body,
        "timestamp" => timestamp
      }
    })

    {:noreply, socket}
  end
end
