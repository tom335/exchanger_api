defmodule Exchanger.Conversions.Conversion do
  @moduledoc """
  The `Ecto.Schema` for the Conversion resource.

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Exchanger.Conversions.Validator

  @derive {Jason.Encoder, only: [:user_id, :from, :to, :rate, :amount, :amount_conv]}
  schema "conversion" do
    field(:user_id, :integer)
    field(:from, :string)
    field(:to, :string)
    field(:rate, :float)
    field(:amount, :float)
    field(:amount_conv, :float)

    timestamps()
  end

  @doc false
  def changeset(conversion, attrs) do
    conversion
    |> cast(attrs, [
      :user_id,
      :from,
      :to,
      :rate,
      :amount,
      :amount_conv
    ])
    |> required(:user_id, "Provide user ID")
    |> required(:from, "Original currency required")
    |> required(:to, "Target currency required")
    |> required(:amount, "Inform the amount")
    |> Validator.validate_currencies()
  end

  defp required(changeset, field, message) do
    validate_required(changeset, [field], message: message)
  end
end
