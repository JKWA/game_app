defmodule GameAppWeb.SuperheroesChannel do
  use Phoenix.Channel
  require Logger
  alias GameApp.Superheroes
  alias GameAppWeb.SuperheroController
  alias Phoenix.PubSub

  @ack_timeout 3_000

  def join("superheroes:lobby", _payload, socket) do
    PubSub.subscribe(GameApp.PubSub, SuperheroController.topic())
    send(self(), :send_initial_superheroes)

    new_socket =
      socket
      |> assign(:superheroes, Superheroes.list_superheroes())
      |> assign(:awaiting_ack, %{})

    {:ok, new_socket}
  end

  def handle_info(:send_initial_superheroes, socket) do
    superheroes = socket.assigns[:superheroes]
    message_id = Ecto.UUID.generate()

    new_socket =
      socket
      |> assign(:awaiting_ack, %{message_id => true})
      |> assign(:superheroes, superheroes)

    push(socket, "hydrate", %{
      superheroes: format_superheroes(superheroes),
      message_id: message_id
    })

    Process.send_after(self(), {:check_ack, message_id}, @ack_timeout)

    {:noreply, new_socket}
  end

  def handle_info({:create, superhero}, socket) do
    updated_superheroes = [superhero | socket.assigns.superheroes]
    message_id = Ecto.UUID.generate()

    new_socket =
      socket
      |> assign(:superheroes, updated_superheroes)
      |> assign(:awaiting_ack, %{message_id => true})
      |> push_update(:create, message_id, superhero)

    {:noreply, new_socket}
  end

  def handle_info({:update, superhero}, socket) do
    existing_superheroes = socket.assigns[:superheroes]
    existing_hero = Enum.find(existing_superheroes, &(&1.id == superhero.id))

    if existing_hero &&
         NaiveDateTime.compare(superhero.updated_at, existing_hero.updated_at) == :gt do
      message_id = Ecto.UUID.generate()

      updated_superheroes =
        Enum.map(existing_superheroes, fn
          hero when hero.id == superhero.id -> superhero
          hero -> hero
        end)

      new_socket =
        socket
        |> assign(:superheroes, updated_superheroes)
        |> assign(:awaiting_ack, %{message_id => true})
        |> push_update(:update, message_id, superhero)

      {:noreply, new_socket}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:delete, superhero}, socket) do
    message_id = Ecto.UUID.generate()

    updated_superheroes =
      Enum.filter(socket.assigns.superheroes, fn
        hero -> hero.id != superhero.id
      end)

    new_socket =
      socket
      |> assign(:superheroes, updated_superheroes)
      |> assign(:awaiting_ack, %{message_id => true})
      |> push_update(:delete, message_id, superhero)

    {:noreply, new_socket}
  end

  def handle_info({:check_ack, message_id}, socket) do
    if Map.has_key?(socket.assigns.awaiting_ack, message_id) do
      Logger.error("No acknowledgment received for message #{message_id}")
      {:stop, :no_ack_received, socket}
    else
      Logger.debug("Acknowledgment received for message #{message_id}")
      {:noreply, socket}
    end
  end

  def handle_in("message_ack", %{"message_id" => message_id, "status" => status}, socket) do
    Logger.debug("Acknowledgment received for message #{message_id} with status: #{status}")

    current_acks = socket.assigns[:awaiting_ack] || %{}
    new_acks = Map.delete(current_acks, message_id)

    new_socket = assign(socket, :awaiting_ack, new_acks)

    {:noreply, new_socket}
  end

  defp push_update(socket, action, message_id, superhero) do
    push(socket, Atom.to_string(action), %{
      superhero: format_superhero(superhero),
      message_id: message_id
    })

    Process.send_after(self(), {:check_ack, message_id}, @ack_timeout)

    socket
  end

  defp format_superheroes(superheroes) do
    Enum.map(superheroes, &format_superhero/1)
  end

  defp format_superhero(superhero) do
    %{
      id: superhero.id,
      name: superhero.name,
      location: superhero.location,
      power: superhero.power
    }
  end
end
