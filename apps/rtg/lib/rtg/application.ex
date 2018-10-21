defmodule Rtg.Application do
  @moduledoc """
  The Rtg Application Service.

  The rtg system business domain lives in this application.

  Exposes API to clients such as the `RtgWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Rtg.Repo, []),
    ], strategy: :one_for_one, name: Rtg.Supervisor)
  end
end
