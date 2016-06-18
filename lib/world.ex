defmodule World do
  import Supervisor.Spec
  def start(_, _) do

    children = [
      supervisor(World.Farm.Supervisor, []),
      worker(World.Farm.Registry, []),
      supervisor(World.Herder.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
