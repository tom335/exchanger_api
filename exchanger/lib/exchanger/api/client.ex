defmodule Exchanger.Api.Client do
  @moduledoc """
  API Client for the ExchangeRatesAPI ([https://exchangeratesapi.io](https://exchangeratesapi.io/)).

  Provides high level methods to retrieve exchange rates between available currencies.
  """

  @base_url "http://api.exchangeratesapi.io"
  @api_version "v1"

  @spec fetch_rates() :: Map
  def fetch_rates() do
    http_client.get(url("/latest")) |> parse_response()
  end

  defp parse_response(%{response: response}) do
    {:ok, body} = Jason.decode(response.body, keys: :atoms)

    case body do
      %{success: _, rates: rates} -> rates
      %{error: %{code: code, message: message}} -> %{}
      _ -> %{}
    end
  end

  defp parse_response(%{reason: reason}) do
    # log the request errors and return an empty list
    %{}
  end

  defp http_client do
    Application.get_env(:exchanger, :http)
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
end
