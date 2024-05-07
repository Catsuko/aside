defmodule Aside.ClientSwarm do
  use GenServer

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def init({task_supervisor, counter, swarm_size}) do
    (1..swarm_size) |> Enum.each(fn(_) -> GenServer.cast(self(), :add_client) end)
    {:ok, {task_supervisor, counter}}
  end

  def handle_cast(:add_client, {task_supervisor, _counter} = state) do
    Task.Supervisor.async_nolink(task_supervisor, fn ->
      Aside.SlowBackend.fetch(:rand.uniform(10))
    end)
    {:noreply, state}
  end

  def handle_info({_ref, {:ok, _result}}, {_task_supervisor, counter} = state) do
    GenServer.cast(counter, :tick)
    GenServer.cast(self(), :add_client)
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end
end
