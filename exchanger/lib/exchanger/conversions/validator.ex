defmodule Exchanger.Conversions.Validator do
  @moduledoc """
    This module provides validation for the `Exchanger.Conversions.Conversion`
    schema, particularly the currencies related fields.
  """

  alias Ecto.Changeset

  @available_currencies [:BRL, :USD, :EUR, :JPY]

  @doc """
  Validates the fields `:from` and `:to` from a Conversion schema.

  Those fields cannot be empty and must be available from
  the list of allowed currencies to be converted.

  Also, they must the different from each other.

  Only add errors if no other field error is found.

  Receives and returns a `changeset`.

  """
  def validate_currencies(changeset) do
    Enum.reduce(
      [
        {&same_currency?/1, [changeset], :to, "Cannot convert to the same currency"},
        {&not_available?/2, [changeset, :from], :from, "Currency not available"},
        {&not_available?/2, [changeset, :to], :to, "Currency not available"}
      ],
      changeset,
      fn {func, args, field, message}, changeset ->
        if apply(func, args) and is_nil(changeset.errors[field]) do
          add_error(changeset, field, message)
        else
          changeset
        end
      end
    )
  end

  defp same_currency?(changeset) do
    changeset.changes[:from] == changeset.changes[:to]
  end

  defp not_available?(changeset, field) do
    val = changeset.changes[field]
    is_nil(val) or String.to_atom(val) not in @available_currencies
  end

  defp add_error(changeset, field, message) do
    Changeset.add_error(changeset, field, message)
  end
end
