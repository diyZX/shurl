defmodule Shurl.Schema.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shurl.Schema.Click

  schema "links" do
    field :url,        :string,  null: false
    field :short_code, :string,  null: false
    field :is_expired, :boolean, null: false, default: false

    has_many :clicks, Click

    timestamps(inserted_at: :created_at)
  end

  def changeset(link, params \\ %{}) do
    link
    |> cast(params, [:url, :short_code, :is_expired])
    |> validate_required([:url, :short_code])
    |> unique_constraint(:url)
    |> unique_constraint(:short_code)
  end
end
