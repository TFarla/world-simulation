defmodule World.Time do
  use GenServer
  require Logger

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, %{}, [name: @name])
  end

  def init(_) do
    # all durations are in ms
    state = %{day: 1_000}
    {:ok, state}
  end

  def send_every(name, pid, message) do
    spawn(fn ->
      duration = get(name)
      :timer.send_after(duration, self, message)
      receive do
        message ->
          send(pid, message)
          send_every(name, pid, message)
      end
    end)
  end

  def get(name) do
    GenServer.call(@name, {:get, name})
  end

  def set(name, value) when is_integer(value) do
    GenServer.cast(@name, {:set, name, value})
  end

  def handle_call({:get, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  def handle_cast({:set, name, value}, state) do
    {:noreply, Map.put(state, name, value)}
  end
end
