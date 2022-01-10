defmodule Exchanger.Api.Controller do
  use Exchanger.Controller  

  alias Exchanger.Conversions.Service
  alias Exchanger.Api.Pagination, as: Pag

  def list_conversions(conn) do
    query = conn |> query_params()
    {page, page_size} = {query[:page], query[:page_size]}

    conn
    |> response(Service.list_conversions(query),
      # success callback function
      fn %{items: items, total_count: total_count} ->
        pag = Pag.build(conn.request_path, page, page_size, total_count)

        # status OK, send conversions
        {:ok, %{conversions: items, pagination: pag}}
      end,

      fn errors ->
        {:malformed_data, %{error: "Request error", details: errors}}
      end)
  end

  def create_conversion(conn) do
    result = Service.create_conversion(conn.body_params)

    conn
    |> response(result,
      fn conversion -> {:created, conversion} end,
      fn errors -> {:unprocessable, %{error: "Validation error", details: errors}}
    end)
  end

  def list_rates(conn) do
    latest = Service.get_latest_rates()
    conn |> send(:ok, %{base: latest.base, rates: latest.rates})
  end

  def handle_errors(conn, reason) do
    conn
    |> send(conn.status, %{error: "Request error", details: error_message(conn.status, reason)})
  end

  def not_found(conn) do
    conn |> send(:not_found, %{error: "Resource not found"})
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
end
