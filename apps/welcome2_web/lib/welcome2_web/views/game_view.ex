defmodule Welcome2Web.GameView do
  use Welcome2Web, :view

  defp move_options(moves) do
    for move <- moves do
      move_option(move)
    end
  end

  defp move_option(move) when is_atom(move) do
    Atom.to_string(move)
  end

  defp move_option(move) when is_tuple(move) do
    move |> Tuple.to_list() |> Enum.join(" ")
  end
end
