defmodule RtgWeb.Js do
  @moduledoc """
  Entry point of ElixirScript.
  """

  alias ElixirScript.JS
  alias ElixirScript.Web

  @pi :math.pi()

  def main do
    canvas = Web.Document.getElementById("rtg-main")
    ctx = canvas.getContext("2d")
    Web.Window.requestAnimationFrame(fn _ -> draw(canvas, ctx) end)
    Web.Console.log(__MODULE__.Date.now())
  end

  defp draw(canvas, ctx) do
    w = canvas.offsetWidth
    h = canvas.offsetHeight
    if canvas.width != w, do: JS.mutate(canvas, "width", w)
    if canvas.height != h, do: JS.mutate(canvas, "height", h)
    ctx.clearRect(0, 0, w, h)
    JS.mutate(ctx, "fillStyle", "#000")
    ctx.fillRect(0, 0, w, h)
    JS.mutate(ctx, "fillStyle", "rgba(0,0,0,1.0)")
    JS.mutate(ctx, "strokeStyle", "#FFF")
    JS.mutate(ctx, "lineWidth", 1.0)
    ctx.beginPath()
    ctx.arc(w / 2, h / 2, 100, 0, @pi * 2)
    ctx.stroke()
    Web.Window.requestAnimationFrame(fn _ -> draw(canvas, ctx) end)
  end
end
