defmodule Exchanger.Api.HttpClient do
  alias Exchanger.Api.Http
  @behaviour Http

  @impl Http
  def get(url) do
    case request(:get, url) do
      {:ok, response} -> response
      {:error, error} -> error # %{reason: :reason_atom}
    end
  end

  @impl Http
  def request(method, url) do
    Finch.build(method, url, [{"content-type", "application/json"}])
    |> Finch.request(ExFinch)
  end
end