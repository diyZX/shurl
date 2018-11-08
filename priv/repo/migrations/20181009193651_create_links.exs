defmodule Shurl.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url,        :string,  null: false
      add :short_code, :string,  null: false
      add :is_expired, :boolean, null: false, default: true

      timestamps(inserted_at: :created_at)
    end

    create index(:links, [:url],        unique: true)
    create index(:links, [:short_code], unique: true)
  end
end
