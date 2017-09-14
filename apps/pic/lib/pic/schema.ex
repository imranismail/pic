defmodule Pic.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      def new(attrs \\ %{}) do
        struct(__MODULE__, attrs)
      end
    end
  end
end
