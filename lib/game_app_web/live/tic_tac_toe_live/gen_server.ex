defmodule GameAppWeb.TicTacToeLive.GenServer do
  @moduledoc """
  LiveView for Tic Tac Toe game.
  """

  use GameAppWeb, :live_view
  alias GameApp.Games.TicTacToe.Registry
  alias GameAppWeb.TicTacToeLive.Board
  alias GameAppWeb.TicTacToeLive.Navigate

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-8">
      <.live_component module={Navigate} id="navigate_1" />

      <.live_component
        module={Board}
        id="gen_server_game_board_1"
        game_state={assigns.game_state}
        game_server={assigns.game_server}
      />
    </div>
    """
  end

  @impl true
  @doc """
  Mounts the LiveView and subscribes to the TicTacToe topic.
  """
  def mount(%{"server" => server}, _session, socket) do
    server_atom = String.to_existing_atom(server)
    state = Registry.get_state(server_atom)

    Phoenix.PubSub.subscribe(GameApp.PubSub, state.topic)

    new_socket =
      socket
      |> assign(game_state: state)
      |> assign(tictactoe_server: server_atom)
      |> assign(game_server: server)

    {:ok, new_socket}
  end

  @impl true
  @doc """
  Handles the client events to reset the game state and mark a position on the board.
  """
  def handle_event("reset", _, socket) do
    Registry.reset(socket.assigns.tictactoe_server)
    {:noreply, socket}
  end

  @impl true
  def handle_event("crash", _, socket) do
    Registry.crash_server(socket.assigns.tictactoe_server)
    {:noreply, socket}
  end

  @impl true
  def handle_event("mark", %{"position" => position}, socket) do
    Registry.mark(socket.assigns.tictactoe_server, String.to_atom(position))
    {:noreply, socket}
  end

  @impl true
  @doc """
  Handles the update message from PubSub to update the game state.
  """
  def handle_info({:update, new_state}, socket) do
    {:noreply, assign(socket, game_state: new_state)}
  end

  def handle_info({:crash, _state}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "Server crashed!")}
  end
end
