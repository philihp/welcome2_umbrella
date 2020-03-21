defmodule Welcome2GameTest do
  use ExUnit.Case
  doctest Welcome2Game

  test "greets the world" do
    assert Welcome2Game.hello() == :world
  end
end
