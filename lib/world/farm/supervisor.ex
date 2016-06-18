defmodule World.Farm.Supervisor do
  use Supervisor
  require Logger

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: @name])
  end

  def init(_) do
    children = [
      worker(World.Farm.Cabbage, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def add_cabbage() do
    resp = {:ok, pid} = Supervisor.start_child(@name, [])
    Logger.info("FARM #{inspect pid}: New cabbage started")
    resp
  end

  def eat_cabbage(cabbage) do
    Supervisor.terminate_child(@name, cabbage)
  end
end
