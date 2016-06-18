defmodule World.Herder.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    resp = {:ok, _} = Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
    loop
    resp
  end

  def init(_) do
    children = [
      worker(World.Herder.Sheep, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  defp loop do
    spawn_link(fn ->
      :timer.sleep(20000)
      add_sheep()
      loop
    end)
  end

  def add_sheep() do
    Logger.info("HERDER: A new sheep is born")
    Supervisor.start_child(__MODULE__, [])
  end
end
