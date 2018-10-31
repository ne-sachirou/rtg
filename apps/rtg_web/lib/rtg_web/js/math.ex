defmodule RtgWeb.Js.Math do
  use ElixirScript.FFI, global: true, name: Math

  defexternal(sin(x))
end
