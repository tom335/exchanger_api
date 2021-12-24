defmodule Exchanger.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Exchanger.Api.Router

  @opts Router.init([])

  test "invalid content type: raises exception" do
    conn =
      :post
      |> conn("/api/conversions", "")
      |> put_req_header("content-type", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
