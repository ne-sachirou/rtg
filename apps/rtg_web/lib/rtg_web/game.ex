defmodule RtgWeb.Game do
  @moduledoc false

  alias RtgWeb.Game
  alias RtgWeb.Game.Worker

  use Supervisor

  def start_link(_), do: Supervisor.start_link(__MODULE__, nil, name: __MODULE__)

  @impl Supervisor
  def init(_) do
    children = [
      Game.Supervisor,
      {Registry, keys: :unique, name: Game.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec create :: Worker.id()
  def create do
    id = 32 |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false)
    DynamicSupervisor.start_child(Game.Supervisor, {Game.Worker, id: id})
    id
  end

  @spec join(Worker.id(), Worker.player()) :: any
  def join(id, player), do: GenServer.cast(worker_name(id), {:join, player})

  @spec move_to(Worker.id(), Worker.player(), {non_neg_integer, non_neg_integer}, non_neg_integer) ::
          any
  def move_to(id, player, dest, anim_end),
    do: GenServer.cast(worker_name(id), {:move_to, player, dest, anim_end})

  @spec worker_name(Worker.id()) :: GenServer.name()
  def worker_name(id), do: {:via, Registry, {Game.Registry, id}}
end
