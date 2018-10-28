defmodule RtgWeb.Js.Date do
  use ElixirScript.FFI, global: true, name: Date

  defexternal(now())
end
