defmodule Exchanger.Controller do
  import Plug.Conn

  defmacro __using__(_opts) do
    quote location: :keep do
      alias Exchanger.Controller

      def send(conn, code, data), do:
        Controller.send(conn, code, data)

      def response(conn, result, success_fn, error_fn), do:
        Controller.response(conn, result, success_fn, error_fn)

      def body_params(conn), do:
        Controller.map_keys_to_atoms(conn.body_params)

      def query_params(conn), do:
        Controller.map_keys_to_atoms(conn.query_params)
    end
  end

  def response(conn, result, success_fn, error_fn) do
    case result do
      {:ok, content} ->
        {status_code, content} = success_fn.(content)
        conn |> send(status_code, content)

      {:error, errors} ->
        {status_code, content} = error_fn.(errors)
        conn |> send(status_code, content)
    end
  end

  def send(conn, code, data) when is_atom(code) do
    http_codes = [
      ok: 200,
      created: 201,
      not_found: 404,
      malformed_data: 400,
      unprocessable: 422,
      server_error: 500,
      error: 504
    ]

    send(conn, http_codes[code], data)
  end
  
  def send(conn, code, data) when is_integer(code) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(data))
  end

  def map_keys_to_atoms(map) do
    map
    |> Enum.reduce(%{}, fn {k, v}, m -> Map.put(m, String.to_atom(k), v) end)
  end
end

