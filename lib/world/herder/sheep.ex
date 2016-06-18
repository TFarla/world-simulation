defmodule World.Herder.Sheep do
  use GenServer
  require Logger

  def start_link do
    resp = {:ok, pid} = GenServer.start_link(__MODULE__, [], [])
    :timer.send_interval(10000, pid, :eat)
    :timer.send_after(50000, spawn(fn ->
      receive do
        :die -> die()
      end
    end), :die)
    resp
  end

  def init([]) do
    {:ok, %{days_without_eating: 0}}
  end

  def handle_info(:eat, state = %{days_without_eating: days_without_eating}) do
    case World.Farm.Registry.get_cabbage() do
      nil ->
        Logger.info("SHEEP <#{inspect self}>: No food found")
        if (days_without_eating == 2) do
          die()
        end

        {:noreply, %{state | days_without_eating: days_without_eating + 1}}
      cabbage ->
        Logger.info("SHEEP <#{inspect self}>: Eating cabage <#{inspect cabbage}>")
        World.Farm.Supervisor.eat_cabbage(cabbage)
        {:noreply, %{state | days_without_eating: 0}}
    end
  end

  defp die() do
    Logger.info("SHEEP <#{inspect self}>: has died")
    Process.exit(self, :normal)
  end
end
