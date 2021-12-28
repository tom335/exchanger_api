defmodule Exchanger.Conversions.ServiceTest do
  use ExUnit.Case, async: true

  # alias Exchanger.Conversions.Conversion
  alias Exchanger.Conversions.Service

  test "create_conversion/1: errors found, all fields missing" do
    {:error, errors} = Service.create_conversion(%{})

    assert errors[:to] != nil
  end

  test "create_conversion/1: errors founds, currency not available" do
    {:error, errors} =
      Service.create_conversion(%{
        from: "BRL",
        to: "NON_AV",
        amount: 123
      })

    assert errors[:to] == "Currency not available"
  end

  test "create_conversion/1: validation passed, save entity" do
    {:ok, conversion} =
      Service.create_conversion(%{
        from: "BRL",
        to: "USD",
        amount: 12,
        amount_conv: 0.0,
        user_id: 1
      })

    assert conversion.from == "BRL"
  end

  test "save_rates/1: saving a list of rates succeeded" do
    {:ok, rates} = save_rates()

    refute Enum.empty?(rates.rates)
  end

  test "get_latest_rates/2: get the latest saved rates" do
    {:ok, ins_rates} = save_rates()

    rates = Service.get_latest_rates()

    assert rates.inserted_at == ins_rates.inserted_at
  end

  test "convert/3: convert amount success" do
    {:ok, _rates} = save_rates()

    # attempt to convert 10BRL to USD
    {amount, _} = Service.convert("BRL", "USD", 10.0)

    assert amount == 1.75739
  end

  defp save_rates() do
    Service.save_rates(%{
      BRL: 6.43,
      USD: 1.13,
      GPB: 0.84
    })
  end
end
