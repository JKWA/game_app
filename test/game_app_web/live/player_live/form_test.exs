defmodule GameAppWeb.PlayerLiveFormTest do
  use GameAppWeb.ConnCase

  import Phoenix.LiveViewTest

  @moduletag :player
  @moduletag :database
  @moduletag :live_view

  @valid_attrs %{
    name: Faker.Person.name(),
    email: Faker.Internet.email(),
    score: Faker.random_between(1, 100_000)
  }
  @invalid_attrs %{name: nil, email: "INVAID_EMAIL", score: -1}
  @url "/players/new"

  defp get_url(player), do: ~p"/players/#{player.id}/edit"

  describe "New" do
    setup [:create_player_1]

    test "success: creates valid player", %{conn: conn} do
      {:ok, view, _html} = live(conn, @url)

      view
      |> form("#player-form", player: @valid_attrs)
      |> render_submit()

      assert_patch(view, ~p"/players")

      assert_player_in_table(view, @valid_attrs)

      assert has_flash?(view, :info)
    end

    test "failure: does not create invalid player", %{conn: conn} do
      {:ok, view, _html} = live(conn, @url)

      view
      |> form("#player-form", player: @invalid_attrs)
      |> render_submit()

      assert has_error_message?(view, :player, "name")
      assert has_error_message?(view, :player, "email")
      assert has_error_message?(view, :player, "score")
    end

    test "failure: does not create player with existing email", %{conn: conn, player_1: player_1} do
      attrs = Map.put(@valid_attrs, :email, player_1.email)

      {:ok, view, _html} = live(conn, @url)

      view
      |> form("#player-form", player: attrs)
      |> render_submit()

      assert has_error_message?(view, :player, "email")
    end
  end

  describe "Edit" do
    setup [:create_player_1]

    test "success: will update valid values", %{conn: conn, player_1: player_1} do
      attrs = %{
        name: Faker.Person.name(),
        email: player_1.email,
        score: player_1.score + 1
      }

      {:ok, view, _html} = live(conn, get_url(player_1))

      view
      |> form("#player-form", player: attrs)
      |> render_submit()

      assert_patch(view, ~p"/players")

      assert_player_in_table(view, attrs)

      assert has_flash?(view, :info)
    end

    test "failure: will not update invalid values", %{conn: conn, player_1: player_1} do
      {:ok, view, _html} = live(conn, get_url(player_1))

      view
      |> form("#player-form", player: @invalid_attrs)
      |> render_change()

      assert has_error_message?(view, :player, "name")
      assert has_error_message?(view, :player, "score")
    end

    test "failure: will not decrement score", %{conn: conn, player_1: player_1} do
      attrs = Map.put(@valid_attrs, :score, player_1.score - 1)

      {:ok, view, _html} = live(conn, get_url(player_1))

      view
      |> form("#player-form", player: attrs)
      |> render_change()

      assert has_error_message?(view, :player, "score")
    end
  end

  defp assert_player_in_table(view, attrs) do
    column = "td"
    assert has_element?(view, column, attrs.email)
    assert has_element?(view, column, attrs.name)
    assert has_element?(view, column, to_string(attrs.score))
  end
end
