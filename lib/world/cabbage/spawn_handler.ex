defmodule World.Cabbage.SpawnHandler do
  use GenEvent
  require Logger

  def handle_event({:spawn, registry, sup}, state) do
    {:ok, pid} = World.Cabbage.Supervisor.add(sup)
    Logger.info("CABBAGE <#{inspect pid}>: has spawned")
    World.Registry.add(registry, pid)
    {:ok, state}
  end
end
