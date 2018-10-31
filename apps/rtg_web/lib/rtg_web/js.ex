defmodule RtgWeb.Js do
  @moduledoc """
  Entry point of ElixirScript.
  """

  alias __MODULE__.Canvas
  alias ElixirScript.Core.Store
  alias ElixirScript.Web

  require Canvas

  def main do
    Store.create(%{}, :rtg)

    Web.Window.addEventListener("DOMContentLoaded", fn _ ->
      "rtg-main"
      |> Canvas.from_id()
      |> Canvas.start([
        {__MODULE__.Bg, []},
        {__MODULE__.Player, []}
      ])
    end)
  end
end
