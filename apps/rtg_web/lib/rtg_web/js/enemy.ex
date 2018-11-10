defmodule RtgWeb.Js.Enemy do
  @moduledoc """
  相手
  """

  alias ElixirScript.JS
  alias RtgWeb.Js.Canvas
  alias RtgWeb.Js.Date
  alias RtgWeb.Js.GameChannel
  alias RtgWeb.Js.Gen2D
  alias RtgWeb.Js.Math

  use Gen2D

  @dialyzer [:no_fail_call, :no_return]

  @type t :: %{}

  @pi :math.pi()
  @radius 60

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

    GameChannel.on("move_to", fn msg, _, _ ->
      msg = JS.object_to_map(msg)
      Gen2D.cast(canvas.__id__, id(), {:move_to, msg.dest, msg.anim_end})
    end)

    {:ok, state}
  end

  @impl Gen2D
  def handle_cast({:move_to, dest, anim_end}, state) do
    now = Date.now()
    state = %{state | prev: state.current, dest: dest, anim: %{start: now, end: anim_end}}
    {:ok, state}
  end

  @impl Gen2D
  def handle_frame(canvas, state) do
    state = next(state)
    Canvas.set(canvas, "strokeStyle", "#F33")
    canvas.context.beginPath()
    canvas.context.arc(state.current.x, state.current.y, @radius, 0, @pi * 2)
    canvas.context.stroke()
    {:ok, state}
  end

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
