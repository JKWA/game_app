defmodule GameAppWeb.PageControllerTest do
  use GameAppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200)
  end
end
