defmodule RtgWeb.Js.Bg do
  @moduledoc """
  背景
  """

  alias RtgWeb.Js.{Canvas, Gen2D}

  use Gen2D

  @impl Gen2D
  def init(_args), do: {:ok, nil}

  @impl Gen2D
  def handle_frame(canvas, state) do
    Canvas.set(canvas, "fillStyle", "#000")
    canvas.context.fillRect(0, 0, canvas.width, canvas.height)
    {:ok, state}
  end
end
