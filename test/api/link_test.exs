defmodule Shurl.API.LinkTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Shurl.{API, Link, TestHelper, TestSeeds}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Shurl.Repo)
  end

  describe "GET requests to /link/:short_code" do
    test "not found link" do
      conn = conn(:get, "/link/absent") |> TestHelper.call
      assert conn.status == 404
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.not_found_response()}
    end

    test "found expited seed link" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.expired_url()})
      conn = conn(:get, "/link/#{link.short_code}") |> TestHelper.call
      assert conn.status == 404
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.expired_response()}
    end

    test "found seed link" do
      {:ok, link} = Link.collect_link(%{url: TestSeeds.url()})
      conn = conn(:get, "/link/#{link.short_code}") |> TestHelper.call
      assert conn.status == 200
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "success", "response" => "#{TestSeeds.url()}"}
    end
  end

  describe "POST requests to /link" do
    test "invalid params" do
      conn = conn(:post, "/link", %{test: "test"}) |> TestHelper.call
      assert conn.status == 422
      assert %{"status" => "error"} = (conn.resp_body |> Jason.decode!)
    end

    test "invalid URL params" do
      conn = conn(:post, "/link", %{url: "test"}) |> TestHelper.call
      assert conn.status == 422
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "error", "response" => API.invalid_url_response()}
    end

    test "create new link" do
      url = "http://test.test"
      {:ok, link} = Link.collect_link(%{url: url})
      conn = conn(:post, "/link", %{url: url}) |> TestHelper.call
      assert conn.status == 200
      assert (conn.resp_body |> Jason.decode!) ==
        %{"status" => "success", "response" => "/#{link.short_code}"}
    end
  end
end
