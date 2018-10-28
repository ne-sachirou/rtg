defmodule RtgWeb.Js.Canvas do
  @moduledoc """
  HTMLCanvasElement context.
  """

  alias ElixirScript.Core.Store
  alias ElixirScript.JS
  alias ElixirScript.Web

  def from_id(id) do
    element = Web.Document.getElementById(id)
    context = element.getContext("2d")
    h = element.offsetHeight
    w = element.offsetWidth
    JS.mutate(element, "height", h)
    JS.mutate(element, "width", w)

    %{
      id: make_ref(),
      context: context,
      element: element,
      height: h,
      width: w
    }
  end

  def loop(canvas, callback, state) do
    put_state(canvas, state)
    loop(canvas, callback)
  end

  def loop(canvas, callback) do
    state = get_state(canvas)
    h = canvas.element.offsetHeight
    w = canvas.element.offsetWidth

    canvas =
      if canvas.width != w or canvas.height != h do
        JS.mutate(canvas.element, "height", h)
        JS.mutate(canvas.element, "width", w)
        %{canvas | height: h, width: w}
      else
        canvas
      end

    canvas.context.clearRect(0, 0, w, h)
    state = callback.(canvas, state)
    put_state(canvas, state)
    Web.Window.requestAnimationFrame(fn _ -> loop(canvas, callback) end)
    canvas
  end

  def on_click(canvas, callback) do
    canvas.element.addEventListener("click", fn event ->
      state = get_state(canvas)
      event.preventDefault()
      event.stopPropagation()
      state = callback.(canvas, %{x: event.layerX, y: event.layerY}, state)
      put_state(canvas, state)
    end)

    canvas
  end

  def set(canvas, property, value) do
    JS.mutate(canvas.context, property, value)
    canvas
  end

  defp get_state(canvas) do
    {:ok, state} = Map.fetch(Store.read(:rtg), canvas.id)
    state
  end

  defp put_state(canvas, state),
    do: Store.update(:rtg, Map.put(Store.read(:rtg), canvas.id, state))
end
