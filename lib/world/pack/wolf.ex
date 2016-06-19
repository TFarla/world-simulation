defmodule World.Pack.Wolf do
  use GenServer
  require Logger

  def start_link do
    resp = {:ok, pid} = GenServer.start_link(__MODULE__, %{}, [])
    Logger.log("WOLF <#{inspect pid}>: was born")
    :timer.send_interval(10000, pid, :eat)
    resp
  end

  def handle_info(:eat, state) do
    {:noreply, state}
  end
end
