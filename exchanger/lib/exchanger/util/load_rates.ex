defmodule Exchanger.Util.LoadRates do
  @moduledoc """
  This module is intended to help on populating the
  rates table.
  """

  alias Exchanger.Api.Client
  alias Exchanger.Conversions.Service

  @doc """
  Calls the Exchanges API client, retrieves the latest
  rates and saves in the database.
  """
  def load do
    rates = Client.fetch_rates()
    Service.save_rates(rates)
  end
end
