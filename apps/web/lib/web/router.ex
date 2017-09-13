defmodule Web.Router do
  use Web, :router

  # get "/", to: Web.PageController, init_opts: [action: :index]
  match _, do: send_resp(conn, 404, "Nothing to see here")
end
