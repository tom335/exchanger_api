defmodule Exchanger.Api.Http do

  alias Finch.{Response, Error}

  @callback get(String.t) :: Response.t | Error.t
  @callback request(Atom.t, String.t) :: {:ok, Response.t} | {:error, Error.t}

  def get(url), do: impl().get(url) 
  def request(method, endpoint), do: impl().request(method, endpoint)

  defp impl, do: Application.get_env(:exchanger, :http, Exchanger.Api.HttpClient)
end