defmodule Web.ControllerHelper do
  alias Plug.Conn

  @encoders %{
    "json" => &JSON.encode!/1
  }

  def put_view(conn, view) do
    Conn.put_private(conn, :view, view)
  end

  def render(conn, assigns) do
    assigns   = Enum.into(assigns, %{}) |> Map.put(:conn, conn)
    extension = extension(conn)
    type      = MIME.type(extension)
    action    = conn.private.action
    template  = Enum.join([action, extension], ".")
    encoder   = encoder(extension)
    content   = do_render(conn, template, encoder, assigns)

    conn
    |> Conn.put_resp_content_type(type)
    |> Conn.send_resp(conn.status || :ok, content)
  end

  def render(conn, template, assigns) do
    assigns   = Enum.into(assigns, %{}) |> Map.put(:conn, conn)
    extension = extension(template)
    encoder   = encoder(extension)
    type      = MIME.type(extension)
    content   = do_render(conn, template, encoder, assigns)

    conn
    |> Conn.put_resp_content_type(type)
    |> Conn.send_resp(conn.status || :ok, content)
  end

  def render(conn, view, template, assigns) do
    assigns   = Enum.into(assigns, %{}) |> Map.put(:conn, conn)
    extension = extension(template)
    encoder   = encoder(extension)
    type      = MIME.type(extension)
    content   = encoder.(view.render(template, assigns))

    conn
    |> Conn.put_resp_content_type(type)
    |> Conn.send_resp(conn.status || :ok, content)
  end

  def scrub_params(%{__struct__: mod} = struct) when is_atom(mod) do
    struct
  end
  def scrub_params(param) when is_map(param) do
    Enum.reduce(param, %{}, fn({k, v}, acc) ->
      Map.put(acc, k, scrub_params(v))
    end)
  end
  def scrub_params(param) when is_list(param) do
    Enum.map(param, &scrub_params/1)
  end
  def scrub_params(param) do
    if scrub?(param), do: nil, else: param
  end

  defp scrub?(" " <> rest), do: scrub?(rest)
  defp scrub?(""), do: true
  defp scrub?(_), do: false

  defp do_render(conn, template, encoder, assigns) do
    template
    |> conn.private.view.render(assigns)
    |> encoder.()
  end

  defp accept_type(conn) do
    conn
    |> Conn.get_req_header("accept")
    |> List.first()
  end

  defp extension(%Conn{} = conn) do
    conn
    |> accept_type()
    |> MIME.extensions()
    |> List.first()
    |> Kernel.||("json")
  end

  defp extension(template) when is_binary(template) do
    ~r/.*\.(\w*)/
    |> Regex.run(template, capture: :all_but_first)
    |> List.first()
    |> Kernel.||("json")
  end

  defp encoder(extension) do
    Map.get(@encoders, extension, fn any -> any end)
  end
end
