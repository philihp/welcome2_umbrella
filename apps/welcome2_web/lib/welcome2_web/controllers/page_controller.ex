defmodule Welcome2Web.PageController do
  use Welcome2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
