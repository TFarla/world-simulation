defmodule World do
  import Supervisor.Spec
  alias World.Time.Duration
  def start(_, _) do
    cabbage_r = :cabbage_registry
    sheep_r = :sheep_registry

    children = [
      worker(World.Time, []),
      supervisor(World.Cabbage.Supervisor, []),
      registry(cabbage_r, [name: cabbage_r]),
      registry(sheep_r, [name: sheep_r]),
      spawner(%Duration{amount: 1, name: :day}, World.Cabbage.SpawnHandler, cabbage_r, :cabbage_spawner),
      spawner(%Duration{amount: 10, name: :day}, World.Sheep.SpawnHandler, sheep_r, :sheep_spawner),
      supervisor(World.Pack.Pack, []),
      supervisor(World.Sheep.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp registry(id, opts) do
    worker(World.Registry, [opts], id: id)
  end

  defp spawner(duration, handler, registry, id, opts \\ []) do
    worker(World.Spawner, [duration, handler, registry, [opts]], id: id)
  end
end
