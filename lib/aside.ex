defmodule Aside do
  use Application

  @reporting_interval 1
  @swarm_size 10

  def start(_type, _args) do
    children = [
      {Aside.TimedCounter, 0},
      {Aside.PeriodicReporter, {Aside.TimedCounter, :timer.seconds(@reporting_interval)}},
      {Task.Supervisor, name: Aside.ClientSupervisor},
      {Aside.ClientSwarm, {Aside.ClientSupervisor, Aside.TimedCounter, @swarm_size}}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
