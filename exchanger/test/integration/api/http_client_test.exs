defmodule Exchanger.Api.HttpClientTest do
  use ExUnit.Case, async: true

  alias Exchanger.Api.HttpClient

  @base_url "https://api.github.com"

  test "request error: url doesn't exist" do
    # expect a Mint.TransportError
    {:error, error} = HttpClient.request(:get, "http://invalid_url")

    assert error.reason == :nxdomain
  end

  test "request succeeded: API error, not found" do
    {:ok, response} = HttpClient.request(:get, @base_url <> "/lksoua89sdjldk")

    {:ok, json} = Jason.decode(response.body, keys: :atoms)
    
    assert json.message == "Not Found"
  end

  test "request succeeded: zen returned" do
    {:ok, response} = HttpClient.request(:get, @base_url <> "/zen")

    assert is_binary(response.body)
  end
end

