defmodule RtgWeb.PageController do
  use RtgWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
