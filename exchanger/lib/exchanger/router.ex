defmodule Exchanger.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  forward("/api", to: Exchanger.Api.Router)

end
