defmodule World.Farm do
  use Supervisor

  def start_link(registry, sup, duration) do
    Supervisor.start_link(__MODULE__, {registry, sup, duration}, [])
  end

  def init({registry, sup, duration}) do
    handler = World.Cabbage.SpawnHandler

    children = [
      worker(World.Registry, [[name: registry]]),
      worker(World.Spawner, [duration, handler, registry, sup, []]),
      supervisor(World.Cabbage.Supervisor, [[name: sup]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
