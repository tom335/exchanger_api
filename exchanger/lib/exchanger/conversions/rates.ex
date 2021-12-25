defmodule Exchanger.Conversions.Rates do
  @moduledoc """
  The `Ecto.Schema` for the Rates resource.

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Exchanger.Conversions.Validator

  schema "rates" do
    field :rates, :map

    timestamps()
  end

  @doc false
  def changeset(rates, attrs) do
    rates
    |> cast(attrs, [
      :rates
    ])
  end
end
