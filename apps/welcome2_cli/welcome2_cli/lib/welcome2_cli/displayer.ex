defmodule Welcome2Cli.Displayer do
  alias Welcome2Cli.State

  def display(
        state = %State{
          view: %{
            winner: winner,
            player: player,
            plan1: plan1,
            plan1_used: plan1_used,
            plan2: plan2,
            plan2_used: plan2_used,
            plan3: plan3,
            plan3_used: plan3_used,
            shown1: shown1,
            shown2: shown2,
            shown3: shown3,
            deck1_suit: deck1_suit,
            deck2_suit: deck2_suit,
            deck3_suit: deck3_suit
          }
        }
      ) do
    IO.puts("================================================================================")
    IO.puts("WINNER: #{winner}")
    IO.puts("Plan 1:   #{plancard(plan1, plan1_used)}")
    IO.puts("Plan 2:   #{plancard(plan2, plan2_used)}")
    IO.puts("Plan 3:   #{plancard(plan3, plan3_used)}")
    IO.puts("Permit 1: #{permit(shown1, deck1_suit)}")
    IO.puts("Permit 2: #{permit(shown2, deck2_suit)}")
    IO.puts("Permit 3: #{permit(shown3, deck3_suit)}")
    IO.puts("")
    IO.puts("a " <> row(player, :a))
    IO.puts("b " <> row(player, :b))
    IO.puts("c " <> row(player, :c))
    IO.puts("    1⏎  2⏎  3⏎  4⏎  5⏎  6⏎  7⏎  8⏎  9⏎ 10⏎ 11⏎ 12⏎")
    IO.puts("Plans:  Parks:    Pools: " <> pools(player) <> "  Estate:  1  2  3  4  5  6")

    IO.puts(
      "1: " <>
        plan(player, 1) <>
        "   a: " <>
        park(player, :a) <>
        "     Temps: " <>
        temps(player) <>
        "     for: " <>
        estate(player, 1) <>
        " " <>
        estate(player, 2) <>
        " " <>
        estate(player, 3) <>
        " " <> estate(player, 4) <> " " <> estate(player, 5) <> " " <> estate(player, 6)
    )

    IO.puts(
      "2: " <>
        plan(player, 2) <> "   b: " <> park(player, :b) <> "       Bis: " <> bis(player) <> ""
    )

    IO.puts(
      "3: " <>
        plan(player, 3) <>
        "   c: " <> park(player, :c) <> "  Refusals: " <> refusals(player) <> ""
    )

    state
  end

  defp permit(%{face: face, suit: suit}, next) do
    IO.ANSI.bright() <>
      "#{:io_lib.format("~2b ~-17s", [face, suit])}" <>
      IO.ANSI.reset() <>
      " next -> " <>
      IO.ANSI.bright() <>
      "#{:io_lib.format("~-17s", [next])}" <> IO.ANSI.reset()
  end

  defp plancard(%{needs: needs, points1: points1, points2: points2}, used) do
    "#{pointpoints(points1, !used)}/#{pointpoints(points2, used)} <- #{needs(needs)}"
  end

  defp pointpoints(points, embolden) do
    cond do
      embolden -> IO.ANSI.bright() <> "#{:io_lib.format("~2b", [points])}" <> IO.ANSI.reset()
      true -> "#{:io_lib.format("~2b", [points])}"
    end
  end

  defp needs(needs) do
    needs
    |> Enum.map(fn {estate, num} -> "#{estate}: #{num}" end)
    |> Enum.join(", ")
  end

  defp row(player, row) do
    "|" <>
      for(index <- 1..%{a: 9, b: 10, c: 11}[row], into: "") do
        "#{n(player, row, index)}#{f(player, row, index)}"
      end <>
      n(player, row, %{a: 10, b: 11, c: 12}[row]) <>
      "|"
  end

  defp f(player, row, number) do
    case Map.get(player, :"fence#{row}#{number}") do
      true -> "|"
      false -> " "
    end
  end

  defp n(player, row, index) do
    number = Map.get(player, :"row#{row}#{index}number")

    suffix =
      cond do
        Map.get(player, :"row#{row}#{index}bis") ->
          "b"

        Map.get(player, :"row#{row}#{index}pool") === true ->
          "p"

        Map.get(player, :"row#{row}#{index}pool", :invalid) === false && number === nil ->
          IO.ANSI.faint() <> "." <> IO.ANSI.reset()

        true ->
          " "
      end

    n_bright(player, row, index) <>
      case number do
        nil -> "  "
        _ -> fmt(number, 2)
      end <> suffix <> IO.ANSI.reset()
  end

  defp n_bright(player, row, index) do
    cond do
      Map.get(player, :"row#{row}#{index}plan") -> IO.ANSI.faint()
      true -> IO.ANSI.bright()
    end
  end

  defp pools(player) do
    fmt(player.pools, 2)
  end

  defp plan(player, num) do
    fmt(Map.get(player, :"plan#{num}"), 2)
  end

  defp temps(player) do
    fmt(player.temps, 2)
  end

  defp bis(player) do
    fmt(player.bis, 2)
  end

  defp refusals(player) do
    fmt(player.refusals, 2)
  end

  defp park(player, row) do
    fmt(Map.get(player, :"park#{row}"), 2)
  end

  defp estate(player, size) do
    fmt(Map.get(player, :"estate#{size}"), 2)
  end

  defp fmt(n, pad) do
    n
    |> Integer.to_string()
    |> String.pad_leading(pad)

    # <>IO.ANSI.reset()
  end
end
