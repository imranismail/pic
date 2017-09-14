defmodule Pic do
  alias Pic.Picture
  alias Pic.Repo
  alias Ecto.Changeset

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

  def stream_create_picture(attrs) do
    temp_dir  = Path.join([System.tmp_dir!, "pic-storage-local-storage"])
    changeset = change_picture(%Pic.Picture{}, attrs)
    changeset = Map.put(changeset, :action, :stream_create_picture)
    file      = Changeset.get_change(changeset, :file)

    with %Changeset{valid?: true} <- changeset,
         {:ok, paths}             <- :zip.unzip(File.read!(file.path), cwd: temp_dir) do
      {:ok,
        paths
        |> Enum.filter(&!String.match?(&1, ~r/\_\_MACOSX/))
        |> Enum.map(&Picture.from_path/1)
        |> Task.async_stream(&Repo.insert!/1, timeout: 15000)}
    else
      %Changeset{valid?: false} ->
        {:error, changeset}
      {:error, reason}          ->
        {:error, Changeset.add_error(changeset, :file, "#{reason}")}
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
