defmodule OnepalWeb.PageController do
  use OnepalWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
