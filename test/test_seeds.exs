defmodule Shurl.TestSeeds do
  alias Shurl.{Link, Schema, Storage}

  def url(),         do: "http://example.com/about/index.html?uid=<%token%>"
  def expired_url(), do: "http://example.com/about/expited.html"

  def upsert_link do
    {:ok, link} = Link.collect_link(%{url: url()})
    %Schema.Link{url: link.url, short_code: link.short_code}
    |> Schema.Link.changeset
    |> Storage.Link.upsert_link
  end

  def upsert_expired_link do
    {:ok, link} = Link.collect_link(%{url: expired_url()})
    %Schema.Link{url: link.url, short_code: link.short_code, is_expired: true}
    |> Schema.Link.changeset
    |> Storage.Link.upsert_link
  end
end

Shurl.TestSeeds.upsert_link()
Shurl.TestSeeds.upsert_expired_link()
