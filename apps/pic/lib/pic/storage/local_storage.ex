defmodule Pic.Storage.LocalStorage do
  @behaviour Pic.Storage

  def save(upload, opts) do
    storage_path = Keyword.fetch!(opts, :at)
    extension    = MIME.extensions(picture.content_type) |> List.first()

    File.mkdir_p(storage_path)
    File.cp!(upload.path, Path.join([storage_path, "original.#{extension}"]))

    {:ok, upload}
  end
end
