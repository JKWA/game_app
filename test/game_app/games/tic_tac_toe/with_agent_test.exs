defmodule GameApp.Games.TicTacToe.WithGenTest do
  @moduledoc """
  Tests for the TicTacToe game module.
  """

  use ExUnit.Case, async: false
  alias GameApp.Games.TicTacToe.WithAgent, as: TicTacToe

  setup do
    {:ok, _pid} = TicTacToe.start_link()
    TicTacToe.reset()
    :ok
  end

  describe "mark/1" do
    test "should mark a valid position" do
      :ok = TicTacToe.mark(:a1)
      state = TicTacToe.get_state()
      assert state.board[:a1] == :x
      assert state.current_player == :o
      assert state.win == nil
      assert state.game_status == :ongoing
    end

    test "should not mark an invalid position" do
      assert {:error, :invalid_position} = TicTacToe.mark(:z1)
    end

    test "should not change an occupied position" do
      :ok = TicTacToe.mark(:a1)
      :ok = TicTacToe.mark(:a1)
      state = TicTacToe.get_state()
      assert state.board[:a1] == :x
      assert state.current_player == :o
    end

    test "should detect a win condition" do
      state = TicTacToe.get_state()
      assert state.win == nil
      assert state.game_status == :ongoing

      :ok = TicTacToe.mark(:a1)
      :ok = TicTacToe.mark(:b1)
      :ok = TicTacToe.mark(:a2)
      :ok = TicTacToe.mark(:b2)
      :ok = TicTacToe.mark(:a3)

      state = TicTacToe.get_state()
      assert state.win == [:a1, :a2, :a3]
      assert state.game_status == :win
    end

    test "should detect a tie" do
      state = TicTacToe.get_state()
      assert state.game_status == :ongoing

      :ok = TicTacToe.mark(:a1)
      :ok = TicTacToe.mark(:a2)
      :ok = TicTacToe.mark(:a3)
      :ok = TicTacToe.mark(:b1)
      :ok = TicTacToe.mark(:b3)
      :ok = TicTacToe.mark(:b2)
      :ok = TicTacToe.mark(:c1)
      :ok = TicTacToe.mark(:c3)
      :ok = TicTacToe.mark(:c2)

      state = TicTacToe.get_state()
      assert state.game_status == :tie
      assert state.win == nil
    end
  end

  describe "reset/0" do
    test "resets the game to initial conditions" do
      TicTacToe.reset()
      state = TicTacToe.get_state()
      initial_state = TicTacToe.initial_state()
      assert state == initial_state
    end
  end
end
