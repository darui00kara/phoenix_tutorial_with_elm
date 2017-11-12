defmodule ToyAppWeb.PageController do
  use ToyAppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
