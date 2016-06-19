defmodule World.Herder.Sheep do
  use GenServer
  alias World.Time.Duration
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init([]) do
    {:ok, _} = World.Time.Interval.start_link(self, %Duration{amount: 1, name: :day}, :eat)
    {:ok, _} = World.Time.Timeout.start_link(self, %Duration{amount: 5, name: :day}, :die)
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

  def handle_info(:die, state) do
    die()
    {:noreply, state}
  end

  defp die() do
    Logger.info("SHEEP <#{inspect self}>: has died")
    Process.exit(self, :normal)
  end
end
