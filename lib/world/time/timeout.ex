defmodule World.Time.Timeout do
  use GenServer
  alias World.Time.{Timeout, Duration}
  defstruct  duration: %Duration{}, current: 0, notify: nil, message: nil

  def start_link(pid, %Duration{} = duration, message \\ :done) do
    state = %Timeout{
      notify: pid,
      duration: duration,
      message: message
    }

    GenServer.start_link(__MODULE__, state, [])
  end

  def init(%Timeout{duration: %Duration{name: name}} = state) do
    World.Time.send_every(name, self, :end)
    {:ok, state}
  end

  def handle_info(:end, %Timeout{duration: duration, current: current} = state) do
    new_current = current + 1
    if (duration.amount == new_current) do
      send(state.notify, state.message)
      # TODO: Kill process
    end

    {:noreply, %{state | current: new_current}}
  end
end
