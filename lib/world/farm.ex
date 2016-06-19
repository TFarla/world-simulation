defmodule World.Farm do
  use Supervisor
  alias World.Time.Duration

  def start_link(registry) do
    Supervisor.start_link(__MODULE__, {registry}, [])
  end

  def init({registry}) do
    duration = %Duration{amount: 1, name: :day}
    handler = World.Cabbage.SpawnHandler

    children = [
      worker(World.Registry, [[name: registry]]),
      worker(World.Spawner, [duration, handler, registry, []]),
      supervisor(World.Cabbage.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
