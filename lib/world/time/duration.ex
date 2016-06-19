defmodule World.Time.Duration do
  defstruct amount: 0, name: :day
  alias World.Time.Duration

  def days(n), do: %Duration{amount: n, name: :day}
end
