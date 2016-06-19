defmodule World do
  import Supervisor.Spec
  def start(_, _) do

    children = [
      worker(World.Time, []),
      supervisor(World.Farm.Supervisor, []),
      worker(World.Farm.Registry, []),
      supervisor(World.Herder.Supervisor, []),
      worker(World.Herder.Registry, []),
      supervisor(World.Pack.Pack, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
