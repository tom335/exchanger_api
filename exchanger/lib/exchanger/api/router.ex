defmodule Exchanger.Api.Router do
  use Plug.Router
  use Plug.ErrorHandler
  import Plug.Conn

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason,
    pass: ["application/json"]
  )

  plug(:dispatch)

  @doc """
    ## GET /api/conversions

    Returns all conversions with paginated results.
  """
  get "/conversions" do
    conn |> send(:ok, [%{}])
  end

  @doc """
    ## POST /api/conversions

    Attempts to perform a conversion between currencies. Accepts any of
    the following currencies:

    BRL, USD, EUR, JPY

    Required fields:

    {
      user_id: int       
      from:    string     The original currency, e.g. USD
      to:      string     The target currency
      amount:  decimal    The desired amount to convert from
    }
  """
  post "/conversions" do
    conn |> send(:ok, %{hi: "there"})
  end

  match _ do
    conn |> send(:not_found, %{error: "Resource not found"})
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send(conn, conn.status, "Something went wrong")
  end

  defp send(conn, code, data) when is_integer(code) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(data))
  end

  defp send(conn, code, data) when is_atom(code) do
    code =
      case code do
        :ok -> 200
        :not_found -> 404
        :malformed_data -> 400
        :non_authenticated -> 401
        :forbidden_access -> 403
        :server_error -> 500
        :error -> 504
      end

    send(conn, code, data)
  end
end
