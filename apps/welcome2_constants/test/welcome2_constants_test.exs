defmodule Welcome2ConstantsTest do
  use ExUnit.Case
  doctest Welcome2Constants

  test "greets the world" do
    assert Welcome2Constants.hello() == :world
  end
end
