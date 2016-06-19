defmodule World.Wolf.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    children = [
      worker(World.Wolf, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def add(sup) do
    Supervisor.start_child(sup, [])
  end
end
