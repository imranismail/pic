defmodule Pic.Storage.LocalStorage do
  @behaviour Pic.Storage

  def save(upload, opts) do
    storage_path = Keyword.fetch!(opts, :at)

    File.mkdir_p!(storage_path)
    File.cp!(upload.path, Path.join([storage_path, "original"]))

    {:ok, upload}
  end
end
