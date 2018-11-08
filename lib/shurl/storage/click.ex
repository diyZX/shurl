defmodule Shurl.Storage.Click do
  import Ecto.Query
  alias Shurl.Repo
  alias Shurl.Schema.Click

  ### Transactions

  def get_clicks_report(%{link_id: link_id}) do
    fn ->
      Click
      |> where([c], c.link_id == ^link_id)
      |> group_by([c], c.headers)
      |> select([c], {c.headers, count(c.id)})
      |> Repo.all
    end
    |> Repo.trans
  end

  def insert_click(%Ecto.Changeset{} = click) do
    fn -> click |> Repo.insert end
    |> Repo.trans
  end
end
