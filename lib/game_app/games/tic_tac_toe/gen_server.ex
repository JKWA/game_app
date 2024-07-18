defmodule GameApp.Games.TicTacToe.GenServer do
  @moduledoc """
  A module to handle the Tic Tac Toe game logic and state management using a GenServer.
  """
  use GenServer
  require Logger
  alias GameApp.Games.TicTacToe.GameLogic

  @valid_positions [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]
  @default_topic "gen_server_tic_tac_toe"

  @spec initial_state(GameLogic.topic()) :: GameLogic.t()
  def initial_state(topic) do
    %GameLogic{} |> Map.put(:topic, topic)
  end

  def start_link(opts \\ []) do
    topic = Keyword.get(opts, :topic, @default_topic)
    GenServer.start_link(__MODULE__, initial_state(topic), opts)
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def mark(pid, position) when position in @valid_positions do
    GenServer.call(pid, {:mark, position})
  end

  def mark(_pid, _position), do: {:error, :invalid_position}

  def topic(pid) do
    GenServer.call(pid, :get_topic)
  end

  @doc """
  Crashes the server
  """
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
  def handle_call(:reset, _from, state) do
    new_state = initial_state(state.topic)
    broadcast_update(:update, new_state)
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:get_topic, _from, state) do
    {:reply, state.topic, state}
  end

  @impl true
  def handle_call({:mark, position}, _from, state) do
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
        {:reply, :ok, new_state}

      _ ->
        {:reply, :ok, state}
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
