defmodule Exchanger.Api.ClientTest do
  use ExUnit.Case, async: true

  import Mox

  alias Exchanger.Api.Client

  test "fetch_rates/0: request failed, empty list returned" do
    Exchanger.HttpMock
    |> expect(:get, fn _ -> %{reason: :invalid_url} end)

    assert Enum.empty?(Client.fetch_rates())
  end

  test "fetch_rates/0: request succeed, but API error found" do
    Exchanger.HttpMock
    |> expect(:get, fn _ -> api_response_error() end)

    assert %{} = Client.fetch_rates()
  end

  test "fetch_rates/0: request succeed, rates returned" do
    Exchanger.HttpMock
    |> expect(:get, fn _ -> api_response_success() end)

    assert %{BRL: _, USD: _} = Client.fetch_rates()
  end

  defp api_response_error do
    error = ~s({"error": {"code":"api_error_code", "message":"Error message"}})
    %{body: error}
  end

  defp api_response_success do
    success = ~s({"success": true, "rates": {"BRL": 5.232, "USD": 1.13}})
    %{body: success}
  end
end
