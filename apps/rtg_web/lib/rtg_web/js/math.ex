defmodule RtgWeb.Js.Math do
  @moduledoc false

  use ElixirScript.FFI, global: true, name: Math

  defexternal(sin(x))
end
