defmodule Pic.Storage.S3Storage do
  @behavior Pic.Storage

  def save(_upload, _opts) do
    raise "behavior not implemented"
  end
end
