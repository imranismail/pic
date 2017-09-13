defmodule PicTest do
  use Pic.DataCase

  describe "pictures" do
    alias Pic.Picture
    alias Ecto.UUID
    alias Plug.Upload

    def valid_attrs do
      %{
        file: %Upload{
          path: Upload.random_file!("pic-test"),
          filename: "picture.bmp",
          content_type: "image/bmp"
        }
      }
    end

    def invalid_attrs do
      %{
          file: %Upload{
            path: Upload.random_file!("pic-test"),
            filename: "picture.pdf",
            content_type: "application/pdf"
          }
        }
    end

    def picture_fixture(attrs \\ %{}) do
      {:ok, picture} =
        attrs
        |> Enum.into(valid_attrs())
        |> Pic.create_picture()

      picture
    end

    test "list_pictures/0 returns all pictures" do
      picture = picture_fixture()
      assert Pic.list_pictures() == [picture]
    end

    test "get_picture!/1 returns the picture with given id" do
      picture = picture_fixture()
      assert Pic.get_picture!(picture.id) == picture
    end

    test "create_picture/1 with valid data creates a picture" do
      assert {:ok, %Picture{} = picture} = Pic.create_picture(valid_attrs())
      assert picture.id !== nil
      assert <<"image/", _rest::binary>> = picture.content_type
    end

    test "create_picture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pic.create_picture(invalid_attrs())
      assert {:error, %Ecto.Changeset{}} = Pic.create_picture(%{})
    end

    test "delete_picture/1 deletes the picture" do
      picture = picture_fixture()
      assert {:ok, %Picture{}} = Pic.delete_picture(picture)
      assert_raise Ecto.NoResultsError, fn -> Pic.get_picture!(picture.id) end
    end

    test "change_picture/1 returns a picture changeset" do
      picture = picture_fixture()
      assert %Ecto.Changeset{} = Pic.change_picture(picture)
    end

    test "content type must be image" do
      valid_attrs = valid_attrs()
      invalid_attrs = invalid_attrs()

      assert <<"image/", _rest::binary>> = valid_attrs.file.content_type
      assert <<"application/", _rest::binary>> = invalid_attrs.file.content_type
      assert {:ok, %Picture{}} = Pic.create_picture(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Pic.create_picture(invalid_attrs)
    end
  end
end
