defmodule Exchanger.Conversions.Service do
  @moduledoc """
  Provides all the common data persistence operations for the `Conversion`
  schema. Also integrates with ExchangesAPI client to perform actual
  conversions against the online service.

  """

  import Ecto.Query

  alias Exchanger.Repo
  alias Exchanger.Conversions.Conversion
  alias Exchanger.Conversions.Rates

  @doc """
  Inserts a new conversion into the table; returns errors
  if the validation has failed.
  """
  def save(%{} = data) do
    changes = Conversion.changeset(%Conversion{}, data)

    if changes.valid? do
      Repo.insert(changes)
    else
      {:error, changes.errors}
    end
  end

  def convert(from_rate, to_rate, amount) do
    to_rate * amount / from_rate
  end

  defp fetch_rates(from, to) do
    rates = Rates |> reverse_order() |> Repo.one()
    %{from: rates[from], to: rates[to]}
  end
end
