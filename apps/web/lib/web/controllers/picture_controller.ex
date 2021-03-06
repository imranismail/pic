defmodule Web.PictureController do
  use Web, :controller

  plug Web.PictureView

  def index(conn, _params) do
    pictures = Pic.list_pictures()
    render(conn, pictures: pictures)
  end

  def show(conn, %{"id" => id}) do
    picture = Pic.get_picture!(id)
    render(conn, picture: picture)
  end

  def create(conn, %{"picture" => params}) do
    case Pic.create_picture(params) do
      {:ok, %Pic.Picture{} = picture} ->
        render(conn, "show.json", picture: picture)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Web.ErrorView, "error.json", changeset: changeset)
    end
  end

  def bulk_create(conn, %{"picture" => params}) do
    case Pic.stream_create_picture(params) do
      {:ok, stream} ->
        render(conn, "index.json", pictures: for {:ok, picture} <- stream do
          picture
        end)
      {:error, changeset} ->
        render(conn, Web.ErrorView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Pic.get_picture!()
    |> Pic.delete_picture()

    send_resp(conn, :ok, "")
  end
end
