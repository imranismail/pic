defmodule Web.Router do
  use Web, :router

  get    "/pictures",     to: Web.PictureController, init_opts: [action: :index]
  post   "/pictures",     to: Web.PictureController, init_opts: [action: :create]
  get    "/pictures/:id", to: Web.PictureController, init_opts: [action: :show]
  delete "/pictures/:id", to: Web.PictureController, init_opts: [action: :delete]

  match _, do: send_resp(conn, 404, "Nothing to see here")
end
