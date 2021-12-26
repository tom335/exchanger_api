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
    {:ok, rates} = save_rates()

    # attempt to convert 10BRL to USD
    result = Service.convert(:BRL, :USD, 10.0)

    assert result == 1.75739
  end

  defp save_rates() do
      Service.save_rates(%{
        rates: %{
          BRL: 6.43,
          USD: 1.13,
          GPB: 0.84
        }
      })
  end
end
