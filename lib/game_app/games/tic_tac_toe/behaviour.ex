defmodule GameApp.Games.TicTacToe.Behavior do
  @moduledoc """
  A behaviour module for the Tic Tac Toe GenServer game logic and state management.
  """

  alias GameApp.Games.TicTacToe.GameLogic

  @callback reset(name_or_pid :: term()) :: :ok
  @callback crash_server(name_or_pid :: term()) :: :ok
  @callback get_state(name_or_pid :: term()) :: GameLogic.t()
  @callback mark(name_or_pid :: term(), position :: atom()) :: :ok
end
