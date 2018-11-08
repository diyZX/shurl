defmodule Shurl.Schema.Click do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shurl.Schema.Link

  schema "clicks" do
    field :headers, :string, null: false

    belongs_to :link, Link

    timestamps(inserted_at: :created_at)
  end

  def changeset(click, params \\ %{}) do
    click
    |> cast(params, [:headers])
    |> validate_required([:link_id, :headers])
    |> assoc_constraint(:link)
  end
end
