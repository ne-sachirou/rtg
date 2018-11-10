defmodule RtgWeb.Js.Player do
  @moduledoc """
  自分
  """

  alias RtgWeb.Js.Canvas
  alias RtgWeb.Js.Date
  alias RtgWeb.Js.GameChannel
  alias RtgWeb.Js.Gen2D
  alias RtgWeb.Js.Math

  use Gen2D

  @dialyzer [:no_fail_call, :no_return]

  @type t :: %{
          current: Gen2D.point(),
          prev: Gen2D.point(),
          dest: Gen2D.point(),
          anim: %{start: non_neg_integer, end: non_neg_integer}
        }

  @pi :math.pi()
  @radius 60
  @anim_ms 600

  @impl Gen2D
  def init(args) do
    {_, canvas} = args.find(fn {k, _}, _, _ -> k == :canvas end, args)
    current = %{x: canvas.width / 2, y: canvas.height / 2}

    state = %{
      current: current,
      prev: current,
      dest: current,
      anim: %{start: 0, end: 0}
    }

    {:ok, state}
  end

  @impl Gen2D
  def area?(point, state) do
    dx = state.current.x - point.x
    dy = state.current.y - point.y
    {dx * dx + dy * dy > @radius * @radius, false}
  end

  @impl Gen2D
  def handle_click(point, state) do
    now = Date.now()
    anim_end = now + @anim_ms

    GameChannel.push("move_to", %{
      "dest" => %{"x" => point.x, "y" => point.y},
      "anim_end" => anim_end
    })

    state = %{state | prev: state.current, dest: point, anim: %{start: now, end: anim_end}}
    {:ok, state}
  end

  @impl Gen2D
  def handle_frame(canvas, state) do
    state = next(state)
    Canvas.set(canvas, "strokeStyle", "#FFF")
    canvas.context.beginPath()
    canvas.context.arc(state.current.x, state.current.y, @radius, 0, @pi * 2)
    canvas.context.stroke()
    {:ok, state}
  end

  @spec next(t) :: t
  defp next(state) do
    now = Date.now()

    cond do
      state.current == state.dest ->
        state

      state.anim.end <= now ->
        %{state | current: state.dest, prev: state.dest}

      true ->
        time = Math.sin((now - state.anim.start) / (state.anim.end - state.anim.start) * @pi / 2)
        x = state.prev.x + (state.dest.x - state.prev.x) * time
        y = state.prev.y + (state.dest.y - state.prev.y) * time
        %{state | current: %{x: x, y: y}}
    end
  end
end
