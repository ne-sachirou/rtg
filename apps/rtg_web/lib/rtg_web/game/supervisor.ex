defmodule RtgWeb.Game.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  def start_link(_), do: DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)
end
