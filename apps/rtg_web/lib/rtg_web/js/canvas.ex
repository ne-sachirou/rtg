defmodule RtgWeb.Js.Canvas do
  @moduledoc """
  HTMLCanvasElement context.
  """

  alias ElixirScript.Core.Store
  alias ElixirScript.JS
  alias ElixirScript.Web

  @dialyzer [:no_fail_call, :no_return, :no_unused]

  @type t :: %{
          __id__: reference,
          context: term,
          element: term,
          height: non_neg_integer,
          width: non_neg_integer
        }

  @spec from_id(binary) :: t
  def from_id(id) do
    element = Web.Document.getElementById(id)
    context = element.getContext("2d")
    h = element.offsetHeight
    w = element.offsetWidth
    JS.mutate(element, "height", h)
    JS.mutate(element, "width", w)

    %{
      __id__: make_ref(),
      context: context,
      element: element,
      height: h,
      width: w
    }
  end

  defmacro start(canvas, children) do
    alias RtgWeb.Js.Macro, as: M

    children =
      for {module, args} <- children do
        module_map =
          M.module_to_map(
            module,
            id: [],
            init: [:args],
            area?: [:point, :state],
            handle_cast: [:message, :state],
            handle_click: [:point, :state],
            handle_frame: [:canvas, :state]
          )

        {module_map, args}
      end

    quote do: RtgWeb.Js.Canvas.do_start(unquote(canvas), unquote(children))
  end

  @spec set(t, binary, term) :: t
  def set(canvas, property, value) do
    JS.mutate(canvas.context, property, value)
    canvas
  end

  def cast(id, dest, message) do
    children = get_state(id)

    children =
      children.map(
        fn {module, state}, _, _ ->
          {:ok, state} =
            if dest == module.id.(),
              do: module.handle_cast.(message, state),
              else: {:ok, state}

          {module, state}
        end,
        children
      )

    put_state(id, children)
    :ok
  end

  @doc false
  def do_start(canvas, children) do
    canvas.element.addEventListener("click", &handle_click(&1, canvas))

    children =
      children.map(
        fn child, _, _ ->
          {module, args} =
            case child do
              {module, args} -> {module, args}
              module -> {module, []}
            end

          safe_canvas = canvas |> Map.delete(:element) |> Map.delete(:context)
          {:ok, state} = module.init.(args ++ [canvas: safe_canvas])
          {module, state}
        end,
        children
      )

    put_state(canvas, children)
    Web.Window.requestAnimationFrame(fn _ -> loop(canvas) end)
    canvas
  end

  defp loop(canvas) do
    children = get_state(canvas)
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

    children =
      children.map(
        fn {module, state}, _, _ ->
          {:ok, state} = module.handle_frame.(canvas, state)
          {module, state}
        end,
        children
      )

    put_state(canvas, children)
    Web.Window.requestAnimationFrame(fn _ -> loop(canvas) end)
  end

  defp handle_click(event, canvas) do
    children = get_state(canvas)
    event.preventDefault()
    event.stopPropagation()
    point = %{x: event.layerX, y: event.layerY}
    children.reverse()

    %{children: children} =
      children.reduce(
        fn accm, {module, state}, _, _ ->
          {state, accm} =
            if not accm.stop_propagation? do
              {area?, stop_propagation?} = module.area?.(point, state)
              {:ok, state} = if area?, do: module.handle_click.(point, state), else: {:ok, state}
              {state, %{accm | stop_propagation?: stop_propagation?}}
            else
              {state, accm}
            end

          %{accm | children: [{module, state} | accm.children]}
        end,
        %{children: [], stop_propagation?: false}
      )

    put_state(canvas, children)
  end

  defp get_state(id) when is_reference(id) do
    {:ok, state} = Map.fetch(Store.read(:rtg), id)
    state
  end

  defp get_state(canvas), do: get_state(canvas.__id__)

  defp put_state(id, state) when is_reference(id),
    do: Store.update(:rtg, Map.put(Store.read(:rtg), id, state))

  defp put_state(canvas, state), do: put_state(canvas.__id__, state)
end
