defmodule RtgWeb.MatchingChannel do
  @moduledoc false

  alias Phoenix.Channel
  alias RtgWeb.Matching

  require Logger

  use RtgWeb, :channel

  @impl Channel
  def join("matching:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Channel
  def handle_info(:after_join, socket) do
    Matching.join(%{pid: self()})
    {:noreply, socket}
  end

  def handle_info({:matched, game_id}, socket) do
    msg = %{game: %{id: game_id}}
    Logger.debug(inspect({:out, socket.topic, "matched", msg}))
    push(socket, "matched", msg)
    {:stop, :normal, socket}
  end

  @impl Channel
  def terminate(_reason, _sokcet), do: Matching.leave(%{pid: self()})

  defp authorized?(_payload), do: true
end
