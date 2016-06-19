defmodule World.Time.Interval do
  use GenServer
  alias World.Time.{Interval, Duration}
  defstruct  duration: %Duration{}, notify: nil, message: nil

  def start_link(pid, %Duration{} = duration, message \\ :done) do
    state = %Interval{
      notify: pid,
      duration: duration,
      message: message
    }

    GenServer.start_link(__MODULE__, state, [])
  end

  def init(%Interval{duration: %Duration{name: name}} = state) do
    World.Time.send_every(name, self, :loop)
    {:ok, state}
  end

  def handle_info(:loop, state) do
    send(state.notify, state.message)
    {:noreply, state}
  end
end
