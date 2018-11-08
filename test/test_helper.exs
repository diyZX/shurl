defmodule Shurl.TestHelper do
  def call(conn) do
    Shurl.API.call(conn, Shurl.API.init([]))
  end
end

ExUnit.start
