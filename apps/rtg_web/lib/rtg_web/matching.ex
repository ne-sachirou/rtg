defmodule RtgWeb.Matching do
  @moduledoc false

  alias RtgWeb.Game

  require Logger

  use GenServer

  @type player :: %{
          pid: pid,
          monitor: reference
        }

  @type t :: %{players: [player]}

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec leave(player) :: any
  def leave(player), do: GenServer.cast(__MODULE__, {:leave, player})

  @spec join(player) :: any
  def join(player), do: GenServer.cast(__MODULE__, {:join, player})

  @impl GenServer
  def init(_), do: {:ok, %{players: []}}

  @impl GenServer
  def handle_cast({:leave, player}, state) do
    Logger.debug(inspect({__MODULE__, :leave, player}))

    state =
      update_in(state.players, fn players -> Enum.reject(players, &(&1.pid == player.pid)) end)

    {:noreply, state}
  end

  def handle_cast({:join, player}, state) do
    Logger.debug(inspect({__MODULE__, :join, player}))
    player = put_in(player[:monitor], Process.monitor(player.pid))
    state = state |> update_in([:players], &[player | &1]) |> matching
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:DOWN, ref, :process, _object, _reason}, state) do
    Logger.debug(inspect({__MODULE__, :DOWN, ref}))
    state = update_in(state.players, fn players -> Enum.reject(players, &(&1.monitor == ref)) end)
    {:noreply, state}
  end

  @spec matching(t) :: t
  defp matching(state) do
    {players, matched} =
      state.players
      |> Enum.reverse()
      |> Enum.chunk_every(2)
      |> Enum.split_with(&(length(&1) == 1))

    for players <- matched,
        game_id = Game.create(),
        Logger.debug(inspect({__MODULE__, :matched, game_id, players})) || true,
        player <- players do
      send(player.pid, {:matched, game_id})
      Process.demonitor(player.monitor)
    end

    put_in(state.players, players |> List.flatten() |> Enum.reverse())
  end
end
