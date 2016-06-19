defmodule World.Farm.Registry do
  use GenServer
  alias World.Time.Duration
  require Logger

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: @name])
  end

  def init(state) do
    duration = %Duration{amount: 1, name: :day}
    {:ok, _} = World.Time.Interval.start_link(self, duration, :add)
    {:ok, state}
  end

  def get_cabbage() do
    GenServer.call(@name, :get)
  end

  def handle_call(:get, _from, []), do: {:reply, nil, []}
  def handle_call(:get, _from, [head|tail]) do
    {:reply, head, tail}
  end

  def handle_info(:add, state) do
    {:ok, pid} = World.Farm.Supervisor.add_cabbage
    Process.monitor(pid)
    {:noreply, [pid|state]}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {:noreply, Enum.filter(state, fn (cabbage) ->
      pid == cabbage
    end)}
  end
end
