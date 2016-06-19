defmodule World.Wolf.SpawnHandler do
  use GenEvent
  require Logger

  def handle_event({:spawn, registry, sup}, state) do
    wolves = World.Registry.get_length(registry)

    if wolves * 2 < World.Registry.get_length(:sheep_registry) do
      {:ok, pid} = World.Wolf.Supervisor.add(sup)
      Logger.info("WOLF <#{inspect pid}>: has been born")
      World.Registry.add(registry, pid)
    end

    {:ok, state}
  end
end
