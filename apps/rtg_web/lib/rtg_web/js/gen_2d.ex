defmodule RtgWeb.Js.Gen2D do
  @moduledoc """
  """

  alias RtgWeb.Js.Canvas

  @type point :: {x :: non_neg_integer, y :: non_neg_integer}

  @type state :: term

  @doc ""
  @callback init(args :: term) :: {:ok, state}

  @doc ""
  @callback area?(point, state) :: {area? :: boolean, stop_propagation? :: boolean}

  @doc ""
  @callback handle_click(point, state) :: {:ok, state}

  @doc ""
  @callback handle_frame(Canvas.t(), state) :: {:ok, state}

  defmacro __using__(_opts) do
    quote do
      @behaviour RtgWeb.Js.Gen2D

      def area?(_, _), do: {false, false}

      def handle_click(_, state), do: {:ok, state}

      defoverridable area?: 2, handle_click: 2
    end
  end
end
