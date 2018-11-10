defmodule RtgWeb.Js do
  @moduledoc """
  Entry point of ElixirScript.
  """

  alias __MODULE__.Canvas
  alias __MODULE__.Socket
  alias ElixirScript.Core.Store
  alias ElixirScript.JS
  alias ElixirScript.Web

  require Canvas

  @dialyzer :no_return

  def main do
    Store.create(%{}, :rtg)

    Web.Window.addEventListener("DOMContentLoaded", fn _ ->
      socket = Socket.create("/socket", JS.map_to_object(%{}))
      socket.onError(fn -> Web.Console.error("socket.onError") end)
      socket.onClose(fn -> Web.Console.log("socket.onClose") end)
      socket.connect()
      join_matching(socket)
    end)
  end

  defp join_matching(socket) do
    ch = socket.channel("matching:lobby", JS.map_to_object(%{}))
    ch.onError(fn _ -> Web.Console.error({"ch.onError", ch.topic}) end)
    ch.onClose(fn _, _, _ -> Web.Console.log({"ch.onClose", ch.topic}) end)

    ch.on("matched", fn msg, _, _ ->
      Web.Console.log({"ch.matched", ch.topic, msg})
      msg = JS.object_to_map(msg)
      join_game(socket, msg.game)
    end)

    with res = ch.join() do
      res.receive("ok", fn msg -> Web.Console.log({"conn.ok", ch.topic, msg}) end)
      res.receive("error", fn msg -> Web.Console.error({"conn.error", ch.topic, msg}) end)
      res.receive("timeout", fn -> Web.Console.error({"conn.timeout", ch.topic}) end)
    end
  end

  defp join_game(socket, game) do
    __MODULE__.GameChannel.start(socket, game)

    "rtg-main"
    |> Canvas.from_id()
    |> Canvas.start([
      {__MODULE__.Bg, []},
      {__MODULE__.Enemy, []},
      {__MODULE__.Player, []}
    ])
  end
end
