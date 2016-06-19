defmodule World.Cabbage.SpawnHandler do
  use GenEvent

  def handle_event({:spawn, registry}, state) do
    {:ok, pid} = World.Cabbage.Supervisor.add_cabbage()
    World.Registry.add(registry, pid)
    {:ok, state}
  end
end
