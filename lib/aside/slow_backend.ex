defmodule Aside.SlowBackend do
  def fetch(key) do
    :timer.sleep(:rand.uniform(10_000))
    {:ok, :erlang.phash2(key)}
  end
end
