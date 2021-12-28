defmodule Exchanger.Api.ClientTest do
  use ExUnit.Case, async: true

  alias Exchanger.Api.Client

  test "fetch_rates/0: request succeeded, rates returned" do
    rates = Client.fetch_rates()

    assert rates[:EUR] != nil
  end
end
