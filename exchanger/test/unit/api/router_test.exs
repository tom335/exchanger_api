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

  test "GET /api/conversions/rates " do
    conn = get_req("/conversions/rates")

    assert conn.status == 200
    assert %{rates: _} = decode_resp(conn.resp_body)
  end

  test "GET /api/conversions" do
    assert true
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
    assert content.message == "Unsupported media type text/html"
  end

  test "POST /api/conversions: request failed, malformed JSON" do
    json = ~s({"amount": anything) # bad JSON
    conn = post_json("/api/conversions", json)

    assert_raise Plug.Parsers.ParseError, fn ->
      conn |> Router.call(@opts)
    end

    {status, _, body} = sent_resp(conn)
    content = decode_resp(body)

    assert status == 400
    assert String.starts_with?(content.message, "Malformed request")
  end

  defp post_json(endpoint, body) do
    conn =
      :post
      |> conn("/api/conversions", body)
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
