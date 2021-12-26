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

  @doc """
  Stores exchange rates according to the data reveived
  by the exchanges API.
  """
  def save_rates(%{} = data) do
    rates = Rates.changeset(%Rates{}, data)

    Repo.insert(rates)
  end

  @doc """
  Performs a conversion between currencies.

  Returns the converted value or `nil`.
  """
  def convert(from, to, amount) do
    %{rates: rates} = get_latest_rates()

    [from_rate, to_rate] = [rates[from], rates[to]]

    Float.round(((to_rate * amount) / from_rate), 5)
  end

  @doc """
  Returns the latest Rates result inserted in the database.
  """
  def get_latest_rates() do
    (from r in Rates,
      limit: 1, order_by: [desc: r.inserted_at])
    |> Repo.one
  end
end
