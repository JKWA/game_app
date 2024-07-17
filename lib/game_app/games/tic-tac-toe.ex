defmodule GameApp.Games.TicTacToe do
  @moduledoc """
  A module to handle the Tic Tac Toe game logic and state management using an Agent.
  """

  use Agent
  require Logger

  @tic_tac_toe_topic "tic_tac_toe"
  @valid_positions [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]

  defstruct board: Enum.reduce(@valid_positions, %{}, fn pos, acc -> Map.put(acc, pos, nil) end),
            current_player: :x,
            win: nil,
            game_status: :ongoing

  @type player() :: :x | :o
  @type board() :: %{
          optional(atom) => :x | :o | nil
        }
  @type win() :: list(atom) | nil
  @type game_status() :: :ongoing | :win | :tie
  @type t :: %__MODULE__{
          board: board(),
          current_player: player(),
          win: win(),
          game_status: game_status()
        }
  @type position() :: :a1 | :a2 | :a3 | :b1 | :b2 | :b3 | :c1 | :c2 | :c3

  @doc """
  Returns the initial state of the Tic Tac Toe game.
  """
  @spec initial_state() :: GameApp.Games.TicTacToe.t()
  def initial_state do
    %__MODULE__{}
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
    Agent.start_link(fn -> initial_state() end, opts)
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
  @spec get_state() :: t()
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
  @spec mark(position()) :: :ok | {:error, :invalid_position}
  def mark(position) when position in @valid_positions do
    Agent.update(__MODULE__, fn state ->
      case Map.get(state.board, position) do
        nil ->
          new_board = Map.put(state.board, position, state.current_player)
          {new_player, new_winner, new_game_status} = update_game(state, new_board)

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

  @doc false
  @spec switch_player(player()) :: player()
  defp switch_player(:x), do: :o
  defp switch_player(:o), do: :x

  @doc false
  @spec update_game(t(), board()) :: {player(), win(), game_status()}
  defp update_game(state, new_board) do
    win = check_winner(new_board)

    game_status =
      cond do
        win -> :win
        check_tie(new_board) -> :tie
        true -> :ongoing
      end

    new_player = if win, do: state.current_player, else: switch_player(state.current_player)

    {new_player, win, game_status}
  end

  @doc false
  @spec check_winner(board()) :: win()
  defp check_winner(board) do
    winning_combinations = [
      [:a1, :a2, :a3],
      [:b1, :b2, :b3],
      [:c1, :c2, :c3],
      [:a1, :b1, :c1],
      [:a2, :b2, :c2],
      [:a3, :b3, :c3],
      [:a1, :b2, :c3],
      [:a3, :b2, :c1]
    ]

    Enum.find(winning_combinations, fn combo ->
      [c1, c2, c3] = Enum.map(combo, &Map.get(board, &1))
      c1 == c2 and c2 == c3 and not is_nil(c1)
    end) || nil
  end

  @doc false
  @spec check_tie(board()) :: boolean()
  defp check_tie(board) do
    Map.values(board) |> Enum.all?(&(&1 != nil))
  end

  @doc """
  Returns the topic for broadcasting game updates.

  ## Examples
      iex> GameApp.Games.TicTacToe.topic()
      "tic_tac_toe"
  """
  @spec topic() :: String.t()
  def topic do
    @tic_tac_toe_topic
  end

  @doc false
  @spec broadcast_update(atom(), t()) :: :ok
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
