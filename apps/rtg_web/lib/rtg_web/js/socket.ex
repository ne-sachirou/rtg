defmodule RtgWeb.Js.Socket do
  @moduledoc false

  use ElixirScript.FFI, global: true, name: Phoenix.Socket

  defexternal(create(path, params))
end
