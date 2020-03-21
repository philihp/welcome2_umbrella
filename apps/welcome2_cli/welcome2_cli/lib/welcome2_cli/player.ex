defmodule Welcome2Cli.Player do
  alias Welcome2Cli.{State, Displayer, Prompter, Mover}

  def continue(game) do
    game
    |> Displayer.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play
  end

  def play(%State{view: %{state: "gameover", winner: winner}}) do
    IO.puts("State = gameover")
    IO.puts("Winner = #{winner}")
    exit(:normal)
  end

  def play(game) do
    continue(game)
  end
end
