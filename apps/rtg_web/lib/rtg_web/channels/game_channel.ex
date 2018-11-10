defmodule RtgWeb.GameChannel do
  use RtgWeb, :channel

  alias Phoenix.Channel
  alias RtgWeb.Game

  require Logger

  intercept(["move_to"])

  @impl Channel
  def join("game:" <> game_id, payload, socket) do
    if authorized?(payload) do
      socket = socket |> assign(:game_id, game_id) |> assign(:player, %{pid: self()})
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Channel
  def handle_in("move_to", payload, socket) do
    dest = {payload["dest"]["x"], payload["dest"]["y"]}
    anim_end = payload["anim_end"]
    Game.move_to(socket.assigns.game_id, socket.assigns.player, dest, anim_end)
    {:noreply, socket}
  end

  @impl Channel
  def handle_info(:after_join, socket) do
    Game.join(socket.assigns.game_id, socket.assigns.player)
    {:noreply, socket}
  end

  def handle_info(:game_not_started, socket), do: {:stop, :normal, socket}

  @impl Channel
  def handle_out("move_to", payload, socket) do
    player = payload.player |> Base.decode64!() |> :erlang.binary_to_term()

    if player.pid != self() do
      msg = Map.delete(payload, :player)
      Logger.debug(inspect({:out, socket.topic, "move_to", msg}))
      push(socket, "move_to", msg)
    end

    {:noreply, socket}
  end

  @impl Channel
  def terminate(_reason, _socket), do: :ok

  defp authorized?(_payload), do: true
end
