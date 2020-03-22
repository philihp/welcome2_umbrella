defmodule Welcome2Cli.Interact do
  alias Welcome2Cli.{State, Player}

  def start() do
    connect()
    |> setup_state
    |> Player.play()
  end

  defp setup_state(game) do
    %State{
      service: game,
      view: Welcome2Game.make_move(game, {})
    }
  end

  defp connect do
    Welcome2Game.new_game()
  end
end
