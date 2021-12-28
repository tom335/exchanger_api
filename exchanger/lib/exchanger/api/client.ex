defmodule Exchanger.Api.Client do
  @moduledoc """
  API Client for the ExchangeRatesAPI ([https://exchangeratesapi.io](https://exchangeratesapi.io/)).

  Provides high level methods to retrieve exchange rates between available currencies.
  """

  require Logger

  @base_url "http://api.exchangeratesapi.io"
  @api_version "v1"

  @doc """
  Performs a GET request to ExchangeRates API and retrieve the
  latest rates, having the EUR as the base currency.
  """
  @spec fetch_rates() :: Map
  def fetch_rates() do
    http_client().get(url("/latest")) |> parse_response()
  end

  defp parse_response(%{body: body}) do
    {:ok, json} = Jason.decode(body, keys: :atoms)

    case json do
      %{success: _, rates: rates} -> rates
      %{error: %{code: _code, message: message}} ->
        Logger.warning(message)
        %{}
      _ -> %{}
    end
  end

  defp parse_response(%{reason: reason}) do
    # log the request errors and return an empty map
    Logger.warning(reason)
    %{}
  end

  defp url(endpoint) do
    query = %{
      access_key: Application.get_env(:exchanger, :ex_api_key)
    }

    URI.merge(URI.parse(@base_url), build_path(endpoint, query))
    |> to_string()
  end

  defp build_path(endpoint, query) do
    Enum.join(["/", @api_version, endpoint, "?", URI.encode_query(query)])
  end

  defp http_client do
    Application.get_env(:exchanger, :http)
  end
end
