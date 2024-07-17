defmodule GameAppWeb.TicTacToeLive.Index do
  @moduledoc """
  LiveView for Tic Tac Toe game.
  """

  use GameAppWeb, :live_view
  alias GameApp.Games.TicTacToe

  @impl true
  @doc """
  Mounts the LiveView and subscribes to the TicTacToe topic.
  """
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(GameApp.PubSub, TicTacToe.topic())

    state = TicTacToe.get_state()
    {:ok, assign(socket, game_state: state)}
  end

  @impl true
  @doc """
  Handles the client events to reset the game state and mark a position on the board.
  """
  def handle_event("reset", _, socket) do
    TicTacToe.reset()
    {:noreply, socket}
  end

  @impl true
  @doc """
  Handles the client's event to mark a position on the board.
  """
  def handle_event("mark", %{"position" => position}, socket) do
    TicTacToe.mark(String.to_atom(position))
    {:noreply, socket}
  end

  @impl true
  @doc """
  Handles the update message from PubSub to update the game state.
  """
  def handle_info({:update, new_state}, socket) do
    {:noreply, assign(socket, game_state: new_state)}
  end

  @doc false
  def button_class(assigns, key) do
    is_winner = is_list(assigns.game_state.win) && Enum.member?(assigns.game_state.win, key)

    base_class = "h-32 text-4xl "
    winner_class = if is_winner, do: "bg-green-400 hover:bg-green-400", else: ""

    base_class <> winner_class
  end
end
