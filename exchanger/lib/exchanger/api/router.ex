defmodule Exchanger.Api.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias Exchanger.Api.Controller

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    json_decoder: Jason,
    pass: ["application/json"]
  )

  plug(:dispatch)

  get "/conversions", do: Controller.list_conversions(conn)

  post "/conversions", do: Controller.create_conversion(conn)

  get "/conversions/rates", do: Controller.list_rates(conn)

  match _, do: Controller.not_found(conn)

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _, reason: reason, stack: _}),
    do: Controller.handle_errors(conn, reason)
end
