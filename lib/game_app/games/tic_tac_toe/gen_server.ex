defmodule GameApp.Games.TicTacToe.GenServer do
  @moduledoc """
  A GenServer module to handle Tic Tac Toe game logic and state management.

  This module implements the `GameApp.Games.TicTacToe.Behavior` to manage the game state,
  handle player moves, and broadcast updates using Phoenix PubSub.
  """
  use GenServer
  require Logger
  alias GameApp.Games.TicTacToe.GameLogic
  @behaviour GameApp.Games.TicTacToe.Behavior

  @valid_positions [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]
  @default_topic "gen_server_tic_tac_toe"

  @doc """
  Initializes the game state with a given topic.

  ## Parameters
    - topic: The PubSub topic for broadcasting updates.

  ## Returns
    - The initial game state as a `%GameLogic{}` struct.
  """
  @spec initial_state(GameLogic.topic()) :: GameLogic.t()
  def initial_state(topic) do
    %GameLogic{} |> Map.put(:topic, topic)
  end

  @doc """
  Starts the GenServer with the given options.

  ## Options
    - :topic (optional): The PubSub topic for broadcasting updates. Defaults to `@default_topic`.

  ## Returns
    - `{:ok, pid}` on success.
  """
  def start_link(opts \\ []) do
    topic = Keyword.get(opts, :topic, @default_topic)
    GenServer.start_link(__MODULE__, initial_state(topic), opts)
  end

  @doc """
  Resets the game state.

  ## Parameters
    - pid: The process identifier of the GenServer.

  ## Returns
    - :ok
  """
  @impl true
  def reset(pid) do
    GenServer.cast(pid, :reset)
  end

  @doc """
  Retrieves the current state of the game.

  ## Parameters
    - pid: The process identifier of the GenServer.

  ## Returns
    - The current game state.
  """
  @impl true
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  @doc """
  Marks a position on the game board.

  ## Parameters
    - pid: The process identifier of the GenServer.
    - position: The position to mark (must be a valid position).

  ## Returns
    - :ok if the position is valid.
    - `{:error, :invalid_position}` if the position is invalid.
  """
  @impl true
  def mark(pid, position) when position in @valid_positions do
    GenServer.cast(pid, {:mark, position})
  end

  def mark(_pid, _position), do: {:error, :invalid_position}

  @doc """
  Crashes the server.

  ## Parameters
    - pid: The process identifier of the GenServer.

  ## Returns
    - :ok
  """
  @impl true
  @spec crash_server(pid()) :: :ok
  def crash_server(pid) do
    GenServer.cast(pid, :crash)
  end

  @impl true
  def init(state) do
    broadcast_update(:update, state)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:reset, state) do
    new_state = initial_state(state.topic)
    broadcast_update(:update, new_state)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:mark, position}, state) do
    case Map.get(state.board, position) do
      nil ->
        new_board = Map.put(state.board, position, state.current_player)
        {new_player, new_winner, new_game_status} = GameLogic.update_game(state, new_board)

        new_state = %{
          state
          | board: new_board,
            current_player: new_player,
            win: new_winner,
            game_status: new_game_status
        }

        broadcast_update(:update, new_state)
        {:noreply, new_state}

      _ ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast(:crash, _state) do
    raise "BOMB!!!"
  end

  @spec broadcast_update(atom(), GameLogic.t()) :: :ok
  defp broadcast_update(action, state) do
    case Phoenix.PubSub.broadcast(GameApp.PubSub, state.topic, {action, state}) do
      :ok ->
        :ok

      error ->
        Logger.error("Failed to broadcast game update: #{inspect(error)}")
        :error
    end
  end
end
