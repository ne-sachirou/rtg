defmodule RtgWeb.Js.GameChannel do
  @moduledoc """
  RtgWeb.GameChannelに接続する
  """

  alias ElixirScript.Core.Store
  alias ElixirScript.JS
  alias ElixirScript.Web

  @dialyzer [:no_fail_call, :no_return]

  def start(socket, game) do
    ch = socket.channel("game:" <> game.id, JS.map_to_object(%{}))
    ch.onError(fn _ -> Web.Console.error({"ch.onError", ch.topic}) end)
    ch.onClose(fn _, _, _ -> Web.Console.log({"ch.onClose", ch.topic}) end)

    with res = ch.join() do
      res.receive("ok", fn msg -> Web.Console.log({"conn.ok", ch.topic, msg}) end)
      res.receive("error", fn msg -> Web.Console.error({"conn.error", ch.topic, msg}) end)
      res.receive("timeout", fn -> Web.Console.error({"conn.timeout", ch.topic}) end)
    end

    Store.update(:rtg, Map.put(Store.read(:rtg), __MODULE__, %{channel: ch}))
  end

  def push(event, body) do
    {:ok, %{channel: ch}} = :rtg |> Store.read() |> Map.fetch(__MODULE__)
    ch.push(event, JS.map_to_object(body), 10_000)
  end

  def on(event, callback) do
    {:ok, %{channel: ch}} = :rtg |> Store.read() |> Map.fetch(__MODULE__)
    ch.on(event, callback)
  end
end
