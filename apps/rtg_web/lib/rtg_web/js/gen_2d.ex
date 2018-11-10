defmodule RtgWeb.Js.Gen2D do
  @moduledoc """
  画面に描画される要素
  """

  alias RtgWeb.Js.Canvas

  @dialyzer :no_return

  @type point :: %{x: non_neg_integer, y: non_neg_integer}

  @type state :: term

  def cast(canvas_id, dest, message) do
    Canvas.cast(canvas_id, dest, message)
    :ok
  end

  @doc ""
  @callback init(args :: term) :: {:ok, state}

  @doc ""
  @callback area?(point, state) :: {area? :: boolean, stop_propagation? :: boolean}

  @doc ""
  @callback handle_cast(message :: term, state) :: {:ok, state}

  @doc ""
  @callback handle_click(point, state) :: {:ok, state}

  @doc ""
  @callback handle_frame(Canvas.t(), state) :: {:ok, state}

  defmacro __using__(_opts) do
    quote do
      @behaviour RtgWeb.Js.Gen2D

      def id, do: __MODULE__

      def area?(_, _), do: {false, false}

      def handle_cast(_, state), do: {:ok, state}

      def handle_click(_, state), do: {:ok, state}

      defoverridable area?: 2, handle_cast: 2, handle_click: 2
    end
  end
end
