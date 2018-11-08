defmodule Shurl.API.RedirectTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Shurl.{API, Link, TestHelper, TestSeeds}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Shurl.Repo)
  end

  describe "GET requests to /:short_code" do
    test "not found link" do
      conn = conn(:get, "/absent") |> TestHelper.call
      assert conn.status == 404
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.not_found_response()}
    end

    test "redirect to found seed URL" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.url()})
      conn = conn(:get, "/#{link.short_code}") |> TestHelper.call
      assert conn.status == 302
      assert (Enum.find(conn.resp_headers,
            fn {h, _} -> h == "location" end) |> elem(1)) == link.url
    end

    test "redirect to found seed URL with dynamic param" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.url(), params: %{"token" => "test"}})
      conn = conn(:get, "/#{link.short_code}?token=test") |> TestHelper.call
      assert conn.status == 302
      assert (Enum.find(conn.resp_headers,
            fn {h, _} -> h == "location" end) |> elem(1)) == link.url
    end
  end
end
