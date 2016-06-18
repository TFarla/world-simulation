defmodule World.Farm.Registry do
  use GenServer

  @name __MODULE__

  def start_link do
    resp = {:ok, pid} = GenServer.start_link(__MODULE__, [], [name: @name])
    :timer.send_interval(10000, pid, :add)
    resp
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
    {:noreply, [pid|state]}
  end
end
