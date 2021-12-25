defmodule Exchanger.ValidatorTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset

  alias Exchanger.Conversions.Conversion
  alias Exchanger.Conversions.Validator

  test "validate_currencies/1: error found, currency not available" do
    changeset = Validator.validate_currencies(conversion("NON", "BRL", 12.0))

    refute Enum.empty?(changeset.errors)
    assert changeset.errors[:from]
  end

  test "validate_currencies/1: error found, same currencies" do
    changeset = Validator.validate_currencies(conversion("BRL", "BRL", 12.0))

    refute Enum.empty?(changeset.errors)
    assert changeset.errors[:to]
  end

  test "validate_currencies/1: validation passed, no errors" do
    changeset = Validator.validate_currencies(conversion("BRL", "USD", 12.0))

    assert Enum.empty?(changeset.errors)
    assert changeset.valid?
  end

  defp conversion(from, to, amount) do
    %Conversion{}
    |> cast(
      %{
        to: to,
        from: from,
        amount: amount,
        user_id: 1
      },
      [:to, :from, :amount, :user_id]
    )
  end
end
