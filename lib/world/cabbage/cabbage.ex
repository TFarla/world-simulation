defmodule World.Cabbage do
  use GenServer
  require Logger

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def terminate(state, reason) do
    Logger.info("CABBAGE <#{inspect self}>: has been destroyed")
    :ok
  end
end
