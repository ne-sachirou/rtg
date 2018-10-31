defmodule RtgWeb.PageControllerTest do
  use RtgWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Rtg"
  end
end
