defmodule World.Wolf.SpawnHandler do
  use GenEvent
  require Logger

  def handle_event({:spawn, registry, sup}, state) do
    {:ok, pid} = World.Wolf.Supervisor.add(sup)
    Logger.info("WOLF <#{inspect pid}>: has been born")
    World.Registry.add(registry, pid)
    {:ok, state}
  end
end
