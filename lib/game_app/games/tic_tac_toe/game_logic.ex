defmodule GameApp.Games.TicTacToe.GameLogic do
  @moduledoc """
  A module to handle the Tic Tac Toe game logic.
  """
  @valid_positions [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]

  @default_topic "default__tic_tac_toe_topic"

  defstruct board: Enum.reduce(@valid_positions, %{}, fn pos, acc -> Map.put(acc, pos, nil) end),
            current_player: :x,
            win: nil,
            game_status: :ongoing,
            topic: @default_topic

  @typedoc """
  Represents the player in the game. Can be either `:x` or `:o`.
  """
  @type player() :: :x | :o

  @typedoc """
  Represents the game board. It is a map where the keys are positions and the values are either `:x`, `:o`, or `nil`.
  """
  @type board() :: %{
          optional(atom) => :x | :o | nil
        }

  @typedoc """
  Represents a winning combination of positions, or `nil` if there is no winner.
  """
  @type win() :: list(atom) | nil

  @typedoc """
  Represents the current status of the game. Can be `:ongoing`, `:win`, or `:tie`.
  """
  @type game_status() :: :ongoing | :win | :tie

  @type topic() :: String.t()

  @typedoc """
  Represents the state of the game. It includes:
  - `board`: The current state of the game board.
  - `current_player`: The player whose turn it is.
  - `win`: The winning combination of positions, if any.
  - `game_status`: The current status of the game.
  """
  @type t :: %__MODULE__{
          board: board(),
          current_player: player(),
          win: win(),
          game_status: game_status(),
          topic: topic()
        }

  @typedoc """
  Represents a valid position on the game board.
  """
  @type position() :: :a1 | :a2 | :a3 | :b1 | :b2 | :b3 | :c1 | :c2 | :c3

  @doc """
  Returns the valid positions of the Tic Tac Toe board.
  """
  @spec valid_positions() :: list(position())
  def valid_positions, do: @valid_positions

  @doc """
  takes state and new_board and returns the next player, win, and game status
  """
  @spec update_game(t(), board()) ::
          {player(), win(), game_status()}
  def update_game(state, new_board) do
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
  @spec switch_player(player()) :: player()
  defp switch_player(:x), do: :o
  defp switch_player(:o), do: :x

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
end
