defmodule GameAppWeb.TicTacToeLive.WithAgent do
  @moduledoc """
  LiveView for Tic Tac Toe game.
  """

  use GameAppWeb, :live_view
  alias GameApp.Games.TicTacToe.WithAgent
  alias GameAppWeb.TicTacToeLive.Board
  alias GameAppWeb.TicTacToeLive.Navigate

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-8">
      <.live_component module={Navigate} id="navigate_1" />

      <.live_component
        module={Board}
        id="agent_game_board_1"
        game_state={assigns.game_state}
        game_server="global"
      />
    </div>
    """
  end

  @impl true
  @doc """
  Mounts the LiveView and subscribes to the WithAgent topic.
  """
  def mount(_params, _session, socket) do
    state = WithAgent.get_state()

    Phoenix.PubSub.subscribe(GameApp.PubSub, state.topic)

    {:ok, assign(socket, game_state: state)}
  end

  @impl true
  @doc """
  Handles the client events to reset the game state and mark a position on the board.
  """
  def handle_event("reset", _, socket) do
    WithAgent.reset()
    {:noreply, socket}
  end

  @impl true
  def handle_event("crash", _, socket) do
    WithAgent.crash_server()
    {:noreply, socket}
  end

  @impl true
  def handle_event("mark", %{"position" => position}, socket) do
    WithAgent.mark(String.to_atom(position))
    {:noreply, socket}
  end

  @impl true
  @doc """
  Handles the update message from PubSub to update the game state.
  """
  def handle_info({:update, new_state}, socket) do
    {:noreply, assign(socket, game_state: new_state)}
  end
end
