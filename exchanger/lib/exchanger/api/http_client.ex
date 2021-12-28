defmodule Exchanger.Api.HttpClient do
  @moduledoc """
  Provides basic methods for HTTP requests using Finch.
  """

  alias Exchanger.Api.Http
  @behaviour Http

  @doc """
  Performs a GET request to the given `url`
  """
  @impl Http
  def get(url) do
    case request(:get, url) do
      {:ok, response} -> response
      {:error, error} -> error
    end
  end

  @doc """
  Performs an HTTP request to the given `url` with `method`.
  """
  @impl Http
  def request(method, url) do
    Finch.build(method, url, [{"content-type", "application/json"}])
    |> Finch.request(ExFinch)
  end
end
