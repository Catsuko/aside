defmodule AsideTest do
  use ExUnit.Case
  doctest Aside

  test "greets the world" do
    assert Aside.hello() == :world
  end
end
