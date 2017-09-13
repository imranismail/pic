defmodule Web.Endpoint do
  use Web, :endpoint

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, JSON.Parser],
    pass: ["*/*"],
    json_decoder: JSON

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_Web_key",
    signing_salt: "7qBQTogB"

  plug Web.Router
end
