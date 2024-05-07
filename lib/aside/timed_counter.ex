defmodule Aside.TimedCounter do
  use GenServer

  def start_link(starting_count \\ 0) do
    GenServer.start_link(__MODULE__, starting_count, name: __MODULE__)
  end

  def init(count) do
    {:ok, {timestamp(), count}}
  end

  def timestamp do
    System.system_time(:second)
  end

  def tick do
    GenServer.cast(__MODULE__, :tick)
  end

  def check do
    GenServer.call(__MODULE__, :check)
  end

  def handle_call(:check, _from, {start_time, count} = state) do
    {:reply, {timestamp() - start_time, count}, state}
  end

  def handle_cast(:tick, {start_time, count}) do
    {:noreply, {start_time, count + 1}}
  end
end
