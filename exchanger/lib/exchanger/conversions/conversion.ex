defmodule Exchanger.Conversions.Conversion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversion" do
    field :user_id, :integer
    field :from, :string
    field :to, :string
    field :rate, :string
    field :amount, :decimal
    field :amount_conv, :decimal

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
    ])
    |> validate_required([ :user_id, :from, :to, :amount ])
  end
end
