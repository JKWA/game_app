defmodule GameApp.Games.TicTacToe.Registry do
  @moduledoc """
  Registry for Tic Tac Toe games.
  """
  use GenServer

  alias GameApp.Games.TicTacToe.GenServer, as: TicTacToe
  @behaviour GameApp.Games.TicTacToe.Behavior

  @tic_tac_toe_processes [:tic, :tac, :toe]

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Enum.each(@tic_tac_toe_processes, fn name ->
      {:ok, _pid} = start_tic_tac_toe(name)
    end)

    {:ok, state}
  end

  def start_tic_tac_toe(name) do
    topic = Atom.to_string(name)

    DynamicSupervisor.start_child(
      GameApp.DynamicSupervisor,
      {TicTacToe, [topic: topic, name: name]}
    )
  end

  @impl true
  def reset(name) do
    GenServer.cast(name, :reset)
  end

  @impl true
  def crash_server(name) do
    GenServer.cast(name, :crash)
  end

  @impl true
  @spec get_state(name :: atom()) :: any()
  def get_state(name) do
    GenServer.call(name, :get_state)
  end

  @impl true
  def mark(name, position) do
    GenServer.cast(name, {:mark, position})
  end
end
