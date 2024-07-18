defmodule GameApp.Games.TicTacToe.GenServerTest do
  @moduledoc """
  Tests for the GenServer game module.
  """

  use ExUnit.Case, async: false
  alias GameApp.Games.TicTacToe.GenServer, as: TicTacToe

  setup do
    {:ok, pid} = TicTacToe.start_link(topic: "tic_tac_toe_test")
    on_exit(fn -> Process.exit(pid, :normal) end)
    # TicTacToe.reset(pid)
    {:ok, pid: pid}
  end

  describe "mark/2" do
    test "should mark a valid position", %{pid: pid} do
      :ok = TicTacToe.mark(pid, :a1)
      state = TicTacToe.get_state(pid)
      assert state.board[:a1] == :x
      assert state.current_player == :o
      assert state.win == nil
      assert state.game_status == :ongoing
    end

    test "should not mark an invalid position", %{pid: pid} do
      assert {:error, :invalid_position} = TicTacToe.mark(pid, :z1)
    end

    test "should not change an occupied position", %{pid: pid} do
      :ok = TicTacToe.mark(pid, :a1)
      :ok = TicTacToe.mark(pid, :a1)
      state = TicTacToe.get_state(pid)
      assert state.board[:a1] == :x
      assert state.current_player == :o
    end

    test "should detect a win condition", %{pid: pid} do
      state = TicTacToe.get_state(pid)
      assert state.win == nil
      assert state.game_status == :ongoing

      :ok = TicTacToe.mark(pid, :a1)
      :ok = TicTacToe.mark(pid, :b1)
      :ok = TicTacToe.mark(pid, :a2)
      :ok = TicTacToe.mark(pid, :b2)
      :ok = TicTacToe.mark(pid, :a3)

      state = TicTacToe.get_state(pid)
      assert state.win == [:a1, :a2, :a3]
      assert state.game_status == :win
    end

    test "should detect a tie", %{pid: pid} do
      state = TicTacToe.get_state(pid)
      assert state.game_status == :ongoing

      :ok = TicTacToe.mark(pid, :a1)
      :ok = TicTacToe.mark(pid, :a2)
      :ok = TicTacToe.mark(pid, :a3)
      :ok = TicTacToe.mark(pid, :b1)
      :ok = TicTacToe.mark(pid, :b3)
      :ok = TicTacToe.mark(pid, :b2)
      :ok = TicTacToe.mark(pid, :c1)
      :ok = TicTacToe.mark(pid, :c3)
      :ok = TicTacToe.mark(pid, :c2)

      state = TicTacToe.get_state(pid)
      assert state.game_status == :tie
      assert state.win == nil
    end
  end

  describe "reset/1" do
    test "resets the game to initial conditions", %{pid: pid} do
      TicTacToe.reset(pid)
      state = TicTacToe.get_state(pid)
      initial_state = TicTacToe.initial_state("tic_tac_toe_test")
      assert state == initial_state
    end
  end
end
