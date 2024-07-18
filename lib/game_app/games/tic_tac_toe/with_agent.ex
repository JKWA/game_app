defmodule GameApp.Games.TicTacToe.WithAgent do
  @moduledoc """
  A module to handle the Tic Tac Toe game logic and state management using an Agent.
  """
  use Agent
  require Logger
  alias GameApp.Games.TicTacToe.GameLogic

  @tic_tac_toe_topic "tic_tac_toe"
  @valid_positions [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]

  @doc """
  Returns the initial state of the Tic Tac Toe game.
  """
  @spec initial_state() :: GameLogic.t()
  def initial_state do
    %GameLogic{} |> Map.put(:topic, @tic_tac_toe_topic)
  end

  @doc """
  Starts a new Tic Tac Toe game agent.

  ## Options
    - `opts`: Keyword list of options passed to `Agent.start_link/2`.

  ## Examples
      iex> {:ok, pid} = GameApp.Games.TicTacToe.start_link(name: :tic_tac_toe)
  """
  @spec start_link(Keyword.t()) ::
          {:ok, pid()} | {:error, {:already_started, pid()} | {:shutdown, term()} | term()}
  def start_link(opts \\ []) do
    with {:ok, pid} <- Agent.start_link(fn -> initial_state() end, opts) do
      broadcast_update(:update, initial_state())
      {:ok, pid}
    end
  end

  @doc """
  Resets the game state to the initial state and broadcasts an update.
  """
  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, fn _state ->
      new_state = initial_state()
      broadcast_update(:update, new_state)
      new_state
    end)

    :ok
  end

  @doc """
  Retrieves the current state of the game.
  """
  @spec get_state() :: GameLogic.t()
  def get_state do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Marks the given position on the board with the current player's symbol.

  ## Parameters
    - `position`: The position to be marked (e.g., `:a1`, `:b2`).

  ## Returns
    - `:ok` if the position was successfully marked.
    - `{:error, :invalid_position}` if the position is invalid or already marked.

  ## Examples
      iex> GameApp.Games.TicTacToe.mark(:a1)
      :ok
      iex> GameApp.Games.TicTacToe.mark(:a1)
      {:error, :invalid_position}
  """
  @spec mark(GameLogic.position()) :: :ok | {:error, :invalid_position}
  def mark(position) when position in @valid_positions do
    Agent.update(__MODULE__, fn state ->
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
          new_state

        _ ->
          state
      end
    end)
  end

  def mark(_position), do: {:error, :invalid_position}

  @doc """
  Crashes the Agent intentionally for testing purposes.
  """
  @spec crash_server() :: no_return()
  def crash_server do
    Agent.update(__MODULE__, fn _state ->
      raise "BOMB!!!"
    end)
  end

  # @spec topic() :: String.t()
  # def topic do
  #   @tic_tac_toe_topic
  # end

  @doc false
  @spec broadcast_update(atom(), GameLogic.t()) :: :ok
  defp broadcast_update(action, state) do
    case Phoenix.PubSub.broadcast(GameApp.PubSub, @tic_tac_toe_topic, {action, state}) do
      :ok ->
        :ok

      error ->
        Logger.error("Failed to broadcast game update: #{inspect(error)}")
        :error
    end
  end
end
