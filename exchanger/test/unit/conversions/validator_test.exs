defmodule Exchanger.ValidatorTest do
  use ExUnit.Case, async: true

  alias Exchanger.Conversions.Conversion
  alias Exchanger.Conversions.Validator

  test "validate_currencies/2: error found, currency not available" do
    changeset = Validator.validate_currencies(conversion("NON", "BRL", 12.0))

    assert length(changeset.errors) > 0
    assert changeset.errors[:to]
  end

  test "validate_currencies/2: error found, same currencies" do
    changeset = Validator.validate_currencies(conversion("BRL", "BRL", 12.0))

    assert length(changeset.errors) > 0
    assert changeset.errors[:to]
  end

  defp conversion(to, from, amount) do
    Conversion.changeset(%Conversion{},
      %{to: to, from: from, amount: amount, user_id: 1})
  end
end
