defmodule World.Sheep.SpawnHandler do
  use GenEvent
  require Logger

  def handle_event({:spawn, registry, sup}, state) do
    {:ok, pid} = World.Sheep.Supervisor.add(sup)
    Logger.info("SHEEP <#{inspect pid}>: has been born")
    World.Registry.add(registry, pid)
    {:ok, state}
  end
end
