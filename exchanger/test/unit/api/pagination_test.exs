defmodule Exchanger.Api.PaginationTest do
  use ExUnit.Case, async: true

  alias Exchanger.Api.Pagination

  test "build/4: trivial case, no records" do
    pag = Pagination.build("/api/res", "1", "2", 0)

    assert pag.next_page == nil
    assert pag.prev_page == nil
    assert pag.total_pages == 0
  end

  test "build/4: trivial case, one record" do
    pag = Pagination.build("/api/res", "1", "2", 1)

    assert pag.next_page == nil
    assert pag.prev_page == nil
    assert pag.total_pages == 1
  end

  test "build/4: return pagination map, first page selected" do
    pag = Pagination.build("/api/res", "1", "2", 20)

    assert pag.next_page == 2
    assert pag.prev_page == nil
    assert pag.total_pages == 10
  end

  test "build/4: return pagination map, last page selected" do
    pag = Pagination.build("/api/res", "10", "2", 20)

    assert pag.next_page == nil
    assert pag.prev_page == 9
    assert pag.total_pages == 10
  end

  test "build/4: return pagination map, odd number of records" do
    pag = Pagination.build("/api/res", "1", "4", 13)

    assert pag.next_page == 2
    assert pag.prev_page == nil
    assert pag.total_pages == 4
  end
end
