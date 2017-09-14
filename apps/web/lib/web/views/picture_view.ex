defmodule Web.PictureView do
  use Web, :view

  alias Pic.Picture

  def render("index.json", %{conn: conn, pictures: pictures}) do
    Enum.map(pictures, &render("picture.json", %{conn: conn, picture: &1}))
  end

  def render("show.json", assigns) do
    render("picture.json", assigns)
  end

  def render("picture.json", %{conn: conn, picture: picture}) do
    %{
      id: picture.id,
      content_type: picture.content_type,
      path: Picture.path_for(picture),
      url: Picture.url_for(conn, picture)
    }
  end

  def render("bulk.json", %{pictures: pictures}) do
    Enum.map(pictures, fn picture ->
      %{
        id: picture.id,
        status: picture.status
      }
    end)
  end
end
