defmodule World.Sheep.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(_) do
    children = [
      worker(World.Sheep, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def add_sheep() do
    Logger.info("HERDER: A new sheep is born")
    Supervisor.start_child(__MODULE__, [])
  end
end
