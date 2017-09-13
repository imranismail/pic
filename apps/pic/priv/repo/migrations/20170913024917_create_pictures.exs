defmodule Pic.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content_type, :string

      timestamps()
    end
  end
end
