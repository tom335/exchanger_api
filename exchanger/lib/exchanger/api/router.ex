defmodule Exchanger.Api.Router do
  use Plug.Router
  use Plug.ErrorHandler
  import Plug.Conn

  alias Exchanger.Conversions.Service
  alias Exchanger.Api.Pagination

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    json_decoder: Jason,
    pass: ["application/json"]
  )

  plug(:dispatch)

  get "/conversions" do
    query = map_keys_to_atoms(conn.query_params)
    page = query[:page]
    page_size = query[:page_size]

    case Service.list_conversions(query) do
      {:ok, %{items: items, total_count: total_count}} ->
        pagination = Pagination.build(conn.request_path, page, total_count, page_size)
        conn |> send(:ok, %{conversions: items, pagination: pagination})

      {:error, errors} -> conn |> send(:malformed_data, %{errors: errors})
    end
  end

  get "/conversions/rates" do
    latest = Service.get_latest_rates()
    conn |> send(:ok, %{base: latest.base, rates: latest.rates})
  end

  post "/conversions" do
    case Service.create_conversion(conn.body_params) do
      {:ok, conversion} -> conn |> send(:created, conversion)
      {:error, errors} -> conn |> send(:unprocessable, errors)
    end
  end

  match _ do
    conn |> send(:not_found, %{error: "Resource not found"})
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _, reason: reason, stack: _}) do
    conn
    |> send(conn.status, %{error: "Request error", message: error_message(conn.status, reason)})
  end

  defp send(conn, code, data) when is_integer(code) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(data))
  end

  defp send(conn, code, data) when is_atom(code) do
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

  defp error_message(status_code, reason) do
    case status_code do
      400 -> "Malformed request, unexpected byte at position #{reason.exception.position}"
      422 -> "Unprocessable entity"
      415 -> "Unsupported media type #{reason.media_type}"
      500 -> "Internal server error"
      _ -> "Unknown error"
    end
  end

  defp map_keys_to_atoms(map) do
    map
    |> Enum.reduce(%{}, fn {k, v}, m -> Map.put(m, String.to_atom(k), v) end)
  end
end
