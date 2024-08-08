defmodule GameApp.Services.NotificationsService do
  use GenServer
  alias GameAppWeb.SuperheroPresence
  alias Phoenix.PubSub
  require Logger

  @interval 5000

  def topic(recepient) do
    "notifications:#{recepient}"
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_send_notification()
    {:ok, state}
  end

  @impl true
  def handle_info(:send_notification, state) do
    send_random_notification()
    schedule_send_notification()
    {:noreply, state}
  end

  defp schedule_send_notification do
    Process.send_after(self(), :send_notification, @interval)
  end

  defp send_random_notification do
    presences = SuperheroPresence.list("notifications:lobby")
    usernames = Map.keys(presences)
    timestamp = System.system_time(:second)

    if length(usernames) > 0 do
      recipient = Enum.random(usernames)

      Logger.info("Sending notification to #{recipient}")

      PubSub.broadcast(GameApp.PubSub, topic(recipient), %{
        event: "notification",
        payload: %{
          "body" => "Message to #{recipient} from internal service",
          "timestamp" => timestamp
        }
      })
    end
  end
end
