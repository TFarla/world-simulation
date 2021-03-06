defmodule World.Sheep.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    children = [
      worker(World.Sheep, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def add(pid) do
    Supervisor.start_child(pid, [])
  end
end
