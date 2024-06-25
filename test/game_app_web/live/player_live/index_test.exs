defmodule GameAppWeb.PlayerLiveIndexTest do
  @moduledoc """
  Tests for the `GameAppWeb.PlayerLive.Index` module.
  """
  use GameAppWeb.ConnCase

  import Phoenix.LiveViewTest
  @moduletag :player
  @moduletag :database
  @moduletag :live_view

  @url "/players"
  @new_url "/players/new"

  defp get_edit_url(player), do: ~p"/players/#{player.id}/edit"

  describe "Index" do
    setup [:create_player_1, :create_player_2]

    test "success: lists all players", %{conn: conn, player_1: player_1, player_2: player_2} do
      {:ok, view, _html} = live(conn, @url)

      assert_player_in_table(view, player_1)
      assert_player_in_table(view, player_2)
    end

    test "create player from user_a shows on user_b", %{conn: conn} do
      attrs = %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        score: Faker.random_between(0, 100_000)
      }

      {:ok, user_a_new_view, _html} = live(conn, @new_url)
      {:ok, user_b_view, _html} = live(conn, @url)

      user_a_new_view
      |> form("#player-form", player: attrs)
      |> render_submit()

      assert_player_in_table(user_b_view, attrs)
    end

    test "update player from user_a shows on user_b", %{conn: conn, player_1: player_1} do
      updated_player = %{
        name: Faker.Person.name(),
        email: player_1.email,
        score: player_1.score + 1
      }

      {:ok, user_a_edit_view, _html} = live(conn, get_edit_url(player_1))
      {:ok, user_b_view, _html} = live(conn, @url)

      assert_player_in_table(user_b_view, player_1)

      user_a_edit_view
      |> form("#player-form", player: updated_player)
      |> render_submit()

      assert_player_in_table(user_b_view, updated_player)
    end

    test "delete player_1 from user_a removes player from both user_a and user_b", %{
      conn: conn,
      player_1: player_1
    } do
      updated_player = %{
        name: Faker.Person.name(),
        email: player_1.email,
        score: player_1.score + 1
      }

      {:ok, user_a_view, _html} = live(conn, @url)
      {:ok, user_b_view, _html} = live(conn, @url)
      {:ok, user_c_view, _html} = live(conn, get_edit_url(player_1))

      player_row = "#players-#{player_1.id}"
      assert has_element?(user_a_view, player_row)
      assert has_element?(user_b_view, player_row)

      user_a_view
      |> render_hook("delete", %{"id" => player_1.id})

      # Another user editing a player should not reverse the deletion
      user_c_view
      |> form("#player-form", player: updated_player)
      |> render_submit()

      refute has_element?(user_a_view, player_row)
      refute has_element?(user_b_view, player_row)
    end
  end

  defp assert_player_in_table(view, player) do
    column = "td"

    assert has_element?(view, column, player.email)
    assert has_element?(view, column, player.name)
    assert has_element?(view, column, to_string(player.score))
  end
end
