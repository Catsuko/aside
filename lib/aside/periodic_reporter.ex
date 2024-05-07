defmodule Aside.PeriodicReporter do
  use GenServer

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def init({_counter, interval} = state) do
    report_after(interval)
    {:ok, state}
  end

  def handle_info(:report, {counter, interval} = state) do
    case counter.check do
      {0, _count} -> nil
      stats       -> print_report(stats)
    end
    report_after(interval)
    {:noreply, state}
  end

  defp report_after(interval) do
    Process.send_after(self(), :report, interval)
  end

  defp print_report({seconds_elapsed, count}) do
    IO.puts("#{round(count / seconds_elapsed)}/s")
  end
end
