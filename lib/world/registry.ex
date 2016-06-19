defmodule World.Registry do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def add(pid, item) do
    GenServer.cast(pid, {:add, item})
  end

  def get_length(pid) do
    GenServer.call(pid, :length)
  end

  def handle_call(:get, _from, []), do: {:reply, nil, []}
  def handle_call(:get, _from, [head|tail]) do
    {:reply, head, tail}
  end

  def handle_call(:length, _from, state) do
    {:reply, length(state), state}
  end

  def handle_cast({:add, pid}, state) do
    Process.monitor(pid)
    {:noreply, [pid|state]}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {:noreply, Enum.filter(state, fn (item) ->
      pid == item
    end)}
  end
end
