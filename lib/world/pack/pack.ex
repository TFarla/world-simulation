defmodule World.Pack.Pack do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: @name])
  end

  def init(:ok) do
    children = [
      worker(World.Pack.Wolf, [])
    ]
    
    supervise(children, strategy: :simple_one_for_one)
  end
end
