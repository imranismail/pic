defmodule Pic do
  alias Pic.Picture
  alias Pic.Repo

  def list_pictures do
    Repo.all(Picture)
  end

  def get_picture!(id) do
    Repo.get!(Picture, id)
  end

  def get_picture_by(opts \\ []) do
    Repo.get_by(Picture, opts)
  end

  def create_picture(attrs \\ %{}) do
    %Picture{}
    |> Picture.changeset(attrs)
    |> Repo.insert()
  end

  def update_picture(%Picture{} = picture, attrs \\ %{}) do
    picture
    |> Picture.changeset(attrs)
    |> Repo.update()
  end

  def delete_picture(%Picture{} = picture) do
    Repo.delete(picture)
  end

  def change_picture(%Picture{} = picture, attrs \\ %{}) do
    Picture.changeset(picture, attrs)
  end
end
