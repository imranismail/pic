defmodule Pic.Picture do
  use Pic.Schema

  alias Pic.Storage
  alias Ecto.UUID

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "pictures" do
    field :content_type, :string
    field :file, :any, virtual: true

    timestamps()
  end

  @permitted ~w(id file content_type)a

  @required ~w(file)a

  @store_dir Path.join([File.cwd!, "priv", "uploads"])

  def changeset(picture, attrs \\ %{}) do
    picture
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> prepare_changes(&save_to_storage/1)
  end

  def url_for(conn, picture) do
    opts = [
      scheme: "http",
      host: conn.host,
      port: conn.port,
      path: path_for(picture)
    ]

    URI
    |> struct(opts)
    |> to_string()
  end

  def path_for(picture) do
    extension = MIME.extensions(picture.content_type) |> List.first()
    Path.join(["/uploads", picture.id, "original.#{extension}"])
  end

  def store_dir(path \\ "") do
    Path.join([@store_dir, path])
  end

  def from_path(path) do
    content_type = MIME.from_path(path)
    extension    = MIME.extensions(content_type) |> List.first()
    filename     = Path.basename(path, extension)

    changeset(new(), %{
      file: %Plug.Upload{
        content_type: content_type,
        filename: filename,
        path: path
      }
    })
  end

  defp save_to_storage(changeset) do
    id              = get_change(changeset, :id, UUID.generate())
    {:ok, file}     = fetch_change(changeset, :file)
    {:ok, uploaded} = Storage.save(file, at: store_dir(id))

    changeset
    |> put_change(:id, id)
    |> put_change(:content_type, uploaded.content_type)
    |> validate_required([:content_type])
    |> validate_content_type()
    |> delete_change(:file)
  end

  defp validate_content_type(changeset) do
    validate_change(changeset, :content_type, fn key, value ->
      case value do
        <<"image/", _rest::binary>> ->
          []
        _ ->
          [{key, "content type must be image"}]
      end
    end)
  end
end
