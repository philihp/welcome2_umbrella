defmodule Welcome2Web.PageControllerTest do
  use Welcome2Web.ConnCase

  test "GET /game", %{conn: conn} do
    conn = get(conn, "/game")
    assert html_response(conn, 200) =~ "Welcome2"
  end
end
