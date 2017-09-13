defmodule Pic.Storage do
  @callback save(Conn.Upload.t, Keyword.t) :: {:ok, Conn.Upload.t} | :error

  def save(upload, opts \\ []) do
    storage().save(upload, opts)
  end

  def storage do
    Application.get_env(:pic, :storage, Pic.Storage.LocalStorage)
  end
end
