defmodule Pic.Storage.LocalStorage do
  @behaviour Pic.Storage

  def save(upload, opts) do
    if upload.content_type == "application/zip" do
      unzip_and_save(upload, opts)
    else
      {:ok, ^upload = perform(upload, opts)}
    end
  end

  defp perform(upload, opts) do
    storage_path = Keyword.fetch!(opts, :at)
    File.mkdir_p!(storage_path)
    File.cp!(upload.path, Path.join([storage_path, "original"]))
    upload
  end

  defp unzip_and_save(upload, opts) do
    temp_dir = Path.join([System.tmp_dir!, "pic-storage-local-storage"])

    upload.path
    |> File.read!()
    |> :zip.unzip(cwd: temp_dir)
    |> case do
      {:ok, paths} ->
        {:ok, perform_bulk(paths)}
      {:error, reason} ->
        raise "#{reason}"
    end
  end

  defp perform_bulk(paths) do
    paths
    |> Enum.filter(&!String.match?(&1, ~r/\_\_MACOSX/))
    |> Enum.map(fn path ->
      Plug.Upload
      |> struct(content_type: MIME.from_path(path),
                filename: Path.basename(path, Path.extname(path)),
                path: path)
      |> perform(opts)
    end)
  end
end
