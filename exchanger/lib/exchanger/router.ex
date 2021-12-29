defmodule Exchanger.Router do
  use Plug.Router

  plug Plug.Static,
    at: "/",
    from: "doc/"

  plug(:match)
  plug(:dispatch)

  forward("/api", to: Exchanger.Api.Router)

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, "doc/api.html")
  end

  match _ do
    conn |> send_resp(404, "<h1>404</h1><p>Resource not found</p>")
  end
end
