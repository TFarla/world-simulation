defmodule World.Wolf do
  use GenServer
  require Logger

  alias World.Time.{Duration, Interval, Timeout}

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init([]) do
    Interval.start_link(self, %Duration{amount: 3, name: :day}, :eat)
    Timeout.start_link(self, %Duration{amount: 7, name: :day}, :die)
    {:ok, %{days_without_eating: 0}}
  end

  def handle_info(:eat, state) do
    case World.Registry.get(:sheep_registry) do
      nil ->
        Logger.info("WOLF <#{inspect self}>: no food found")
        if state.days_without_eating == 3 do
          die(self)
        end

        days_without_eating = state.days_without_eating + 1
        {:noreply, %{state | days_without_eating: days_without_eating}}

      sheep ->
        eat(sheep)
        {:noreply, state}
    end
  end

  def handle_info(:die, state) do
    die(self)
    {:noreply, state}
  end

  defp eat(sheep) do
    Logger.info("WOLF <#{inspect self}>: ate sheep <#{inspect sheep}>")
    Process.exit(sheep, :kill)
  end

  defp die(pid) do
    Logger.info("WOLF <#{inspect pid}>: died")
    GenServer.stop(pid)
  end
end
