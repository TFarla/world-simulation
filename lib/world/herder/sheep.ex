defmodule World.Herder.Sheep do
  use GenServer
  require Logger

  def start_link do
    resp = {:ok, pid} = GenServer.start_link(__MODULE__, [], [])
    :timer.send_interval(15000, pid, :eat)
    :timer.send_after(50000, pid, :die)
    resp
  end

  def handle_info(:eat, state) do
    case World.Farm.Registry.get_cabbage() do
      nil ->
        Logger.info("SHEEP <#{inspect self}>: No food found")
      cabbage ->
        Logger.info("SHEEP <#{inspect self}>: Eating cabage <#{inspect cabbage}>")
        World.Farm.Supervisor.eat_cabbage(cabbage)
    end

    {:noreply, state}
  end

  def handle_info(:die, state) do
    Logger.info("SHEEP <#{inspect self}>: has died")
    Process.exit(self, :normal)
    {:noreply, state}
  end
end
