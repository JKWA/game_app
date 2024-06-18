defmodule GameAppWeb.PlayerLiveShowTest do
  use GameAppWeb.ConnCase

  import Phoenix.LiveViewTest

  def get_url(player) do
    ~p"/players/#{player.id}"
  end

  describe "Show" do
    setup [:create_player_1]

    test "success: displays player", %{conn: conn, player_1: player_1} do
      {:ok, _view, html} = live(conn, get_url(player_1))

      assert html =~ player_1.name
      assert html =~ player_1.email
      assert html =~ to_string(player_1.score)
    end

    test "failure: missing player returns to list", %{conn: conn} do
      missing_id = -1

      assert {:error, {:live_redirect, %{to: "/players"}}} =
               live(conn, ~p"/players/#{missing_id}")

      {:ok, view, _html} = live(conn, ~p"/players")

      assert has_flash?(view, :error)
    end
  end
end
