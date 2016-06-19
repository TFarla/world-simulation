defmodule World.Cabbage.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    children = [
      worker(World.Cabbage, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def add(sup) do
    Supervisor.start_child(sup, [])
  end
end
