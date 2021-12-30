defmodule Exchanger.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Exchanger.Api.Router

  @opts Router.init([])

  test "GET /api/nonono: invalid endpoint, not found" do
    conn = get_req("/api/nonono")

    assert conn.status == 404
    assert %{error: "Resource not found"} = decode_resp(conn.resp_body)
  end

  test "GET /api/conversions/rates: returns the latest rates" do
    conn = get_req("/conversions/rates")

    assert conn.status == 200
    assert %{rates: _} = decode_resp(conn.resp_body)
  end

  test "GET /api/conversions: calling without parameters, page 1" do
    conn = get_req("/conversions")

    assert conn.status == 200

    %{conversions: conversions, pagination: pagination} = decode_resp(conn.resp_body)

    assert length(conversions) == 5
    assert pagination[:next_page] == 2
  end

  test "GET /api/conversions?user_id=1: returns only conversions by user" do
    conn = get_req("/conversions?user_id=1")
    assert conn.status == 200

    %{conversions: conversions, pagination: pagination} = decode_resp(conn.resp_body)

    assert Enum.all?(conversions, fn conv -> conv.user_id == 1 end)
    assert pagination[:next_page] == 2
    assert pagination[:total_count] >= 5
  end

  test "POST /api/conversions: invalid content type, raises exception" do
    conn =
      :post
      |> conn("/api/conversions", "")
      |> put_req_header("content-type", "text/html")

    assert_raise Plug.Parsers.UnsupportedMediaTypeError, fn ->
      conn |> Router.call(@opts)
    end

    {status, _, body} = sent_resp(conn)
    content = decode_resp(body)

    assert status == 415
    assert content.details == "Unsupported media type text/html"
  end

  test "POST /api/conversions: request failed, malformed JSON" do
    # bad JSON
    json = ~s({"amount": anything)
    conn = post_json("/api/conversions", json)

    assert_raise Plug.Parsers.ParseError, fn ->
      conn |> Router.call(@opts)
    end

    {status, _, body} = sent_resp(conn)
    content = decode_resp(body)

    assert status == 400
    assert String.starts_with?(content.details, "Malformed request")
  end

  defp post_json(endpoint, body) do
    :post
    |> conn(endpoint, body)
    |> put_req_header("content-type", "application/json")
  end

  defp get_req(endpoint) do
    :get
    |> conn(endpoint, "")
    |> Router.call(@opts)
  end

  defp decode_resp(body) do
    {:ok, json} = Jason.decode(body, keys: :atoms)
    json
  end
end
