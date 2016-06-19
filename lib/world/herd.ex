defmodule World.Herd do
  use Supervisor
  alias World.Time.Duration

  def start_link(registry) do
    Supervisor.start_link(__MODULE__, {registry}, [])
  end

  def init({registry}) do
    duration = %Duration{amount: 10, name: :day}
    handler = World.Sheep.SpawnHandler

    children = [
      worker(World.Registry, [[name: registry]]),
      worker(World.Spawner, [duration, handler, registry, []]),
      supervisor(World.Sheep.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
