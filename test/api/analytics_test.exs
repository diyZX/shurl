defmodule Shurl.API.AnalyticsTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Shurl.{API, Link, TestHelper, TestSeeds}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Shurl.Repo)
  end

  describe "GET requests to /analytics/:short_code" do
    test "not found link" do
      conn = conn(:get, "/analytics/absent") |> TestHelper.call
      assert conn.status == 404
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.not_found_response()}
    end

    test "found expited seed link" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.expired_url()})
      conn = conn(:get, "/analytics/#{link.short_code}") |> TestHelper.call
      assert conn.status == 404
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.expired_response()}
    end

    test "found seed link" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.url()})
      conn = conn(:get, "/analytics/#{link.short_code}") |> TestHelper.call
      assert conn.status == 200
      assert %{"status" => "success", "response" => %{"statistics" => _, "total" => _}} =
        (conn.resp_body |> Jason.decode!)
    end
  end
end
