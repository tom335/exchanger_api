defmodule Exchanger.Api.Pagination do
  @moduledoc """
  Pagination helper to build a map containing useful pages information.

  """

  @page_size 5

  @doc """
  Returns a map with parameters to be used with paginated views or endpoints.

  The parameter `endpoint` serves as reference for build the next/previous links
  to the other pages.

  Example of pagination map:

  ```
  %{
      page: 3,
      total_pages: 3,
      total_count: 9,
      next_page: nil,
      prev_page: 2,
      next_link: nil,
      prev_link: "/api/endpoint?page=2"
  }
  ```
  """
  def build(endpoint, page, total_count, page_size) do
    page = to_int(page, 1)
    page_size = to_int(page_size, @page_size)

    total_pages = ceiling(total_count / page_size)

    next_page = if page + 1 <= total_pages do page + 1 else nil end
    prev_page = if page - 1 > 0 do page - 1 else nil end

    pagination = %{
      page: page,
      total_pages: total_pages,
      total_count: total_count,
      next_page: next_page,
      prev_page: prev_page
    }

    next_prev_links(pagination, endpoint)
  end

  defp next_prev_links(pagination, endpoint) do
    [next_link: pagination.next_page, prev_link: pagination.prev_page]
    |> Enum.reduce(pagination, fn {k, v}, m ->
      if v do
        Map.put(m, k, build_query_str(endpoint, v))
      else
        m
      end
    end)
  end

  defp to_int(value, opt) do
    if is_empty?(value) do
      opt
    else
      String.to_integer(value)
    end
  end

  defp is_empty?(value) do
    is_nil(value) or value == ""
  end

  # replaces the "page" parameter on query params map.
  defp build_query_str(endpoint, page) do
    endpoint <> "?" <> URI.encode_query(%{page: page})
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end
end
