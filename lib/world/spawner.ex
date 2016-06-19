defmodule World.Spawner do
  use GenServer
  alias World.Time.Duration

  def start_link(%Duration{} = duration, handler_module, registry, opts \\ []) do
    GenServer.start_link(__MODULE__, {duration, handler_module, registry}, opts)
  end

  def init({duration, mod, registry}) do
    {:ok, manager} = GenEvent.start_link([])
    GenEvent.add_handler(manager, mod, [])
    {:ok, _} = World.Time.Interval.start_link(self, duration, :spawn)
    {:ok, %{manager: manager, registry: registry}}
  end

  def handle_info(:spawn, %{manager: manager, registry: reg} = state) do
    GenEvent.notify(manager, {:spawn, reg})
    {:noreply, state}
  end
end
