defmodule Exchanger.Conversions.ServiceTest do
  use ExUnit.Case, async: true

  # alias Exchanger.Conversions.Conversion
  alias Exchanger.Conversions.Service

  test "save/1: errors returns, all fields missing" do
    {:error, errors} = Service.save(%{})

    assert errors[:to] != nil
  end

  test "save/1: validation passed, save entity" do
    {:ok, conversion} =
      Service.save(%{
        from: "BRL",
        to: "USD",
        amount: 12.0,
        amount_conv: 0.0,
        rate: 1.2,
        user_id: 1
      })

    assert conversion.from == "BRL"
  end
end
