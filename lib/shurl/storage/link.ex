defmodule Shurl.Storage.Link do
  import Ecto.Query
  alias Ecto.Multi
  alias Shurl.{Repo, Util}
  alias Shurl.Schema.{Link, Click}

  ### Transactions

  def get_link(%{short_code: short_code}) do
    fn ->
      Link
      |> where([l], l.short_code == ^short_code)
      |> Repo.one
    end
    |> Repo.trans
  end

  def upsert_link(%Ecto.Changeset{} = link) do
    fn -> link |> Repo.insert_or_update end
    |> Repo.trans
  end

  def update_expired_links() do
    Multi.new
    |> Multi.run(:links_ids, &get_expired_links_ids(&1))
    |> Multi.run(:expired_links, &update_links_as_expired(&1))
    |> Repo.transaction
  end

  ### Batch SQL-queries

  def get_expired_links_ids(_multi) do
    expiration_moment = NaiveDateTime.add(NaiveDateTime.utc_now(),
      trunc(expiration_time() / -1000))

    links_ids = Link
    |> join(:left, [l], c in Click, l.id == c.link_id)
    |> where([l], l.is_expired == false)
    |> where([l], l.created_at < ^expiration_moment)
    |> group_by([l], l.id)
    |> having([l, c], count(c.id) == 0)
    |> select([l, c], l.id)
    |> Repo.all

    {:ok, links_ids}
  end

  def update_links_as_expired(%{links_ids: links_ids}) do
    params = %{is_expired: true, updated_at: NaiveDateTime.utc_now()}
    query = Link |> where([l], l.id in ^links_ids)
    {_, links} = query
    |> Repo.update_all([set: params |> Util.map_to_keyword_list], [returning: true])

    {:ok, links}
  end

  defp expiration_time() do
    Application.get_env(:shurl, :expiration_time)
  end
end
