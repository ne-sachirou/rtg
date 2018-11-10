defmodule RtgWeb.Js.Socket do
  use ElixirScript.FFI, global: true, name: Phoenix.Socket

  defexternal(create(path, params))
end
