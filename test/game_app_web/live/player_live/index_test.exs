defmodule GameAppWeb.PlayerLiveIndexTest do
  use GameAppWeb.ConnCase

  import Phoenix.LiveViewTest
  @moduletag :player

  @url "/players"

  describe "Index" do
    setup [:create_player_1, :create_player_2]

    test "success: lists all players", %{conn: conn, player_1: player_1, player_2: player_2} do
      {:ok, view, _html} = live(conn, @url)

      assert_player_in_table(view, player_1)
      assert_player_in_table(view, player_2)
    end
  end

  defp assert_player_in_table(view, player) do
    column = "td"

    assert has_element?(view, column, player.email)
    assert has_element?(view, column, player.name)
    assert has_element?(view, column, to_string(player.score))
  end
end
