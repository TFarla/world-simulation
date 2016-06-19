defmodule World do
  import Supervisor.Spec
  alias World.Time.Duration

  def start(_, _) do
    children = [
      worker(World.Time, []),
      supervisor(World.Farm, [:cabbage_registry, :farm_sup, Duration.days(3)]),
      supervisor(World.Herd, [:sheep_registry, :herd_sup, Duration.days(2)]),
      supervisor(World.WolfPack, [:wolf_registry, :wolf_sup, Duration.days(1)])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
