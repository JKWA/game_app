defmodule GameAppWeb.GetTextLiveTest.Index do
  @moduledoc """
  Tests for the `GameAppWeb.GetTextLiveIndexTest.Index` module.
  """
  use GameAppWeb.ConnCase
  alias GameApp.Stubs

  import Phoenix.LiveViewTest
  @moduletag :get_text
  @moduletag :live_view

  @url "/get-text"

  describe "Index" do
    setup do
      Mox.stub_with(GameApp.External.TextExtractMockService, Stubs.TextExtractService)
      :ok
    end

    test "success: valid url gets text ", %{conn: conn} do
      attrs = %{
        url: Faker.Internet.url()
      }

      {:ok, view, _html} = live(conn, @url)

      refute has_result?(view)

      view
      |> form("#get_text_form", get_text: attrs)
      |> render_submit()

      assert has_result?(view)
    end

    test "success: clears result", %{conn: conn} do
      attrs = %{
        url: Faker.Internet.url()
      }

      {:ok, view, _html} = live(conn, @url)

      view
      |> form("#get_text_form", get_text: attrs)
      |> render_submit()

      assert has_result?(view)

      view
      |> element("button[phx-click=\"clear_result\"]")
      |> render_click()

      refute has_result?(view)
    end

    test "failure: shows error on invalid url", %{conn: conn} do
      attrs = %{
        url: Faker.Lorem.word()
      }

      {:ok, view, _html} = live(conn, @url)

      refute has_result?(view)

      view
      |> form("#get_text_form", get_text: attrs)
      |> render_change()

      assert has_error_message?(view, :get_text, "url")
      refute has_result?(view)
    end

    test "failure: does not submit invalid url", %{conn: conn} do
      attrs = %{
        url: Faker.Lorem.word()
      }

      {:ok, view, _html} = live(conn, @url)

      refute has_result?(view)

      view
      |> form("#get_text_form", get_text: attrs)
      |> render_submit()

      assert has_error_message?(view, :get_text, "url")
      assert has_flash?(view, :error)
      refute has_result?(view)
    end

    test "falure: shows service failure", %{conn: conn} do
      attrs = %{
        url: Stubs.TextExtractService.get_error_url()
      }

      {:ok, view, _html} = live(conn, @url)

      refute has_result?(view)

      view
      |> form("#get_text_form", get_text: attrs)
      |> render_submit()

      refute has_result?(view)
      assert has_flash?(view, :error)
    end
  end

  defp has_result?(view) do
    has_element?(view, "div#result")
  end
end
