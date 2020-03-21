defmodule Welcome2CliTest do
  use ExUnit.Case
  doctest Welcome2Cli

  test "greets the world" do
    assert Welcome2Cli.hello() == :world
  end
end
