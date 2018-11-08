defmodule Shurl.Repo.Migrations.CreateClicks do
  use Ecto.Migration

  def change do
    create table(:clicks) do
      add :link_id, references(:links)

      add :headers, :text, null: false

      timestamps(inserted_at: :created_at)
    end

    create index(:clicks, [:headers], unique: false)
  end
end
