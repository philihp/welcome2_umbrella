defmodule Welcome2Cli.Prompter do
  alias Welcome2Cli.State

  def accept_move(game = %State{view: %{moves: moves}}) do
    IO.inspect(moves)

    IO.gets("$ ")
    |> guard_error
    |> String.split()
    |> to_move
    |> check_input(game)
  end

  defp guard_error(:eof) do
    exit(:normal)
  end

  defp guard_error({:error, reason}) do
    IO.puts("Game ended because #{reason}")
    exit(:normal)
  end

  defp guard_error(input) do
    input
  end

  defp to_move([]) do
    :identity
  end

  defp to_move([command]) do
    to_command(command)
  end

  defp to_move([command | params]) do
    List.to_tuple([to_command(command) | Enum.map(params, &to_param/1)])
  end

  defp to_command(command) do
    String.to_atom(command)
  end

  defp to_param(param) when param in ["a", "b", "c"] do
    String.to_atom(param)
  end

  defp to_param(param) do
    param |> Integer.parse() |> to_num
  end

  defp to_num(:error) do
    999
  end

  defp to_num({digit, _}) do
    digit
  end

  defp check_input(move, game = %State{view: %{moves: moves}}) do
    cond do
      move in (moves ++ [:identity]) ->
        Map.put(game, :command, move)

      true ->
        IO.puts("Invalid move")
        accept_move(game)
    end
  end
end
