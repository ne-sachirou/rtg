defmodule RtgWeb.Js do
  @moduledoc """
  Entry point of ElixirScript.
  """

  alias __MODULE__.Canvas
  alias ElixirScript.Core.Store
  alias ElixirScript.JS
  alias ElixirScript.Web

  @pi :math.pi()

  def main do
    Store.create(%{}, :rtg)

    Web.Window.addEventListener("DOMContentLoaded", fn _ ->
      Web.Window.requestAnimationFrame(fn _ ->
        "rtg-main"
        |> Canvas.from_id()
        |> Canvas.loop(&draw/2, %{cnt: 0})
        |> Canvas.on_click(&on_click/3)
      end)
    end)
  end

  defp draw(canvas, state) do
    w = canvas.width
    h = canvas.height
    Canvas.set(canvas, "fillStyle", "#000")
    canvas.context.fillRect(0, 0, w, h)
    canvas |> Canvas.set("fillStyle", "rgba(0,0,0,1.0)") |> Canvas.set("strokeStyle", "#FFF")
    canvas.context.beginPath()
    canvas.context.arc(w / 2, h / 2, 100 + Map.fetch!(state, :cnt), 0, @pi * 2)
    canvas.context.stroke()
    state
  end

  defp on_click(_canvas, _event, state) do
    Web.Console.log(JS.map_to_object(state))
    Map.put(state, :cnt, Map.fetch!(state, :cnt) + 1)
  end
end
