defmodule World do
  import Supervisor.Spec

  def start(_, _) do
    children = [
      worker(World.Time, []),
      supervisor(World.Farm, [:cabbage_registry, :farm_sup]),
      supervisor(World.Herd, [:sheep_registry, :herd_sup]),
      supervisor(World.WolfPack, [:wolf_registry, :wolf_sup])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
