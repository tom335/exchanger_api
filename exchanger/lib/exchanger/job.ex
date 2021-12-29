defmodule Exchanger.FetchRatesJob do
  use GenServer

  require Logger
  alias Exchanger.Util.LoadRates

  @timeout :timer.hours(24)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(state) do
    Logger.info("Starting FetchRatesJob")
    {:ok, state, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    Logger.info("Fetching rates in #{DateTime.utc_now}")
    # fetch rates immediately after application starts
    # LoadRates.load()

    {:noreply, state, @timeout}
  end

  def handle_info(:timeout, state) do
    Logger.info("Fetching rates in #{DateTime.utc_now}")
    # wait 24h before fetching data again
    LoadRates.load()

    {:noreply, state, @timeout}
  end
end
