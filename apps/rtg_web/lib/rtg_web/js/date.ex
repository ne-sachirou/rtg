defmodule RtgWeb.Js.Date do
  @moduledoc false

  use ElixirScript.FFI, global: true, name: Date

  defexternal(now())
end
