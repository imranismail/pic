defmodule Web do
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def router do
    quote do
      use Plug.Router

      if Mix.env == :dev do
        use Plug.Debugger
      end

      use Plug.ErrorHandler

      plug :match
      plug :dispatch

      defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
        send_resp(conn, conn.status, "Something went wrong")
      end
    end
  end

  def endpoint do
    quote do
      use Plug.Builder

      require Logger

      plug :secret_key

      def secret_key(conn, _) do
        Map.put(conn, :secret_key, Application.get_env(:web, :secret_key))
      end

      def start_link do
        Logger.info "Starting server on http://0.0.0.0:4000"
        Plug.Adapters.Cowboy.http(__MODULE__, [])
      end
    end
  end

  def controller do
    quote do
      use Plug.Builder

      import Web.ControllerHelper

      def call(conn, opts) do
        action = Keyword.fetch!(opts, :action)

        conn =
          conn
          |> put_private(:action, action)
          |> super(opts)

        apply(__MODULE__, action, [conn, conn.params])
      end
    end
  end

  def view do
    quote do
      use Plug.Builder

      def call(conn, opts) do
        conn
        |> put_private(:view, __MODULE__)
        |> super(opts)
      end
    end
  end
end
