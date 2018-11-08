defmodule Shurl.APITest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Shurl.TestHelper

  test "absent endpoint" do
    conn = conn(:get, "/") |> TestHelper.call
    assert conn.status == 405
    assert %{"status" => "error"} = conn.resp_body |> Jason.decode!
  end
end
