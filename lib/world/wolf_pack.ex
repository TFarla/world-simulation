defmodule World.WolfPack do
  use Supervisor

  def start_link(registry, sup, duration) do
    Supervisor.start_link(__MODULE__, {registry, sup, duration}, [])
  end

  def init({registry, sup, duration}) do
    handler = World.Wolf.SpawnHandler

    children = [
      worker(World.Registry, [[name: registry]]),
      worker(World.Spawner, [duration, handler, registry, sup, []]),
      supervisor(World.Wolf.Supervisor, [[name: sup]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
