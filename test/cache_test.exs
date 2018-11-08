defmodule Shurl.CacheTest do
  use ExUnit.Case, async: true
  alias Shurl.Cache

  test "read absent key" do
    assert Cache.read("absent") == nil
  end

  test "write value and read it" do
    :ok = Cache.write("exist", "value")
    assert Cache.read("exist") == "value"
  end

  test "rewrite value and read it" do
    :ok = Cache.write("exist", "value")
    assert Cache.read("exist") == "value"
    :ok = Cache.write("exist", "new_value")
    assert Cache.read("exist") == "new_value"
  end
end
