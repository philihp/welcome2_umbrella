defmodule Welcome2Cli.Mover do
  alias Welcome2Cli.State

  def make_move(state = %State{command: command}) do
    %State{
      state
      | view: Welcome2Game.make_move(state.service, command)
    }
  end
end
