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

  def stream_create_picture(upload) do
    temp_dir = Path.join([System.tmp_dir!, "pic-storage-local-storage"])

    upload.path
    |> File.read!()
    |> :zip.unzip(cwd: temp_dir)
    |> case do
      {:ok, paths} ->
        paths
        |> Enum.filter(&!String.match?(&1, ~r/\_\_MACOSX/))
        |> Enum.map(&Picture.from_path/1)
        |> Task.async_stream(&Repo.insert!/1, timeout: 15000)
      {:error, reason} ->
        raise "#{reason}"
    end
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
