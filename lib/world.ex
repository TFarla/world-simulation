defmodule World do
  import Supervisor.Spec

  def start(_, _) do
    children = [
      worker(World.Time, []),
      supervisor(World.Farm, [:cabbage_registry]),
      supervisor(World.Herd, [:sheep_registry])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
