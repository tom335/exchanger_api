defmodule Exchanger.FetchRatesJob do
  @moduledoc """
  This is a timed task which runs at every 12 hours, calling the
  LoadRates.load() utility to fetch the latest rates from the external
  ExchangeRates API.

  If running in production, fetch rates on application start.
  """
  use GenServer

  require Logger
  alias Exchanger.Util.LoadRates

  # Fetch new rates each 12 hours
  @timeout :timer.hours(12)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting FetchRatesJob")
    {:ok, state, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    # fetch rates immediately after application starts
    if Mix.env() == :prod do
      Logger.info(">>> App started :: Fetching rates in #{DateTime.utc_now()} <<<")
      LoadRates.load()
    end

    {:noreply, state, @timeout}
  end

  def handle_info(:timeout, state) do
    Logger.info(">>> Fetching rates in #{DateTime.utc_now()} <<<")
    # wait 12h before fetching data again
    LoadRates.load()

    {:noreply, state, @timeout}
  end
end
