defmodule World.Sheep.SpawnHandler do
  use GenEvent

  def handle_event({:spawn, registry}, state) do
    {:ok, pid} = World.Sheep.Supervisor.add_sheep()
    World.Registry.add(registry, pid)
    {:ok, state}
  end
end
