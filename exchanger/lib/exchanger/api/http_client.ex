defmodule Exchanger.Api.HttpClient do
  @moduledoc """
  Provides basic methods for HTTP requests using Finch.
  """

  alias Exchanger.Api.Http
  @behaviour Http

  @doc """
  Performs a GET request to the given `url`.
  Returns either a Finch.Response or a Finch.Error.
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

  Methods are represented by atoms like:

  ```
  :get
  :post
  :patch
  ```

  """
  @impl Http
  def request(method, url) do
    Finch.build(method, url, [{"content-type", "application/json"}])
    |> Finch.request(ExFinch)
  end
end
