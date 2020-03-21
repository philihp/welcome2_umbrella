defmodule Welcome2Game.GameScorer do
  alias Welcome2Game.{EstateMaker, State, Tableau}

  def score(%State{player: tableau}) do
    %Tableau{
      plan1: plan1,
      plan2: plan2,
      plan3: plan3,
      parka: parka,
      parkb: parkb,
      parkc: parkc,
      pools: pools,
      temps: temps,
      estate1: estate1,
      estate2: estate2,
      estate3: estate3,
      estate4: estate4,
      estate5: estate5,
      estate6: estate6,
      built_estates1: built_estates1,
      built_estates2: built_estates2,
      built_estates3: built_estates3,
      built_estates4: built_estates4,
      built_estates5: built_estates5,
      built_estates6: built_estates6,
      bis: bis,
      roundabout: roundabout,
      refusals: refusals
    } = EstateMaker.update(tableau)

    plan1 +
      plan2 +
      plan3 +
      parka +
      parkb +
      parkc +
      pools_to_points(pools) +
      temps_to_points(temps) +
      estate1 * built_estates1 +
      estate2 * built_estates2 +
      estate3 * built_estates3 +
      estate4 * built_estates4 +
      estate5 * built_estates5 +
      estate6 * built_estates6 +
      bis_to_points(bis) +
      roundabout_to_points(roundabout) +
      refusals_to_points(refusals)
  end

  defp pools_to_points(points) do
    case points do
      0 -> 0
      1 -> 3
      2 -> 6
      3 -> 9
      4 -> 13
      5 -> 17
      6 -> 21
      7 -> 26
      8 -> 31
      true -> 36
    end
  end

  defp bis_to_points(points) do
    case points do
      0 -> 1
      1 -> 1
      2 -> 3
      3 -> 6
      4 -> 9
      5 -> 12
      6 -> 16
      7 -> 20
      8 -> 24
      true -> 28
    end
  end

  defp roundabout_to_points(roundabouts) do
    case roundabouts do
      0 -> 0
      1 -> 0
      2 -> -3
      true -> -8
    end
  end

  defp temps_to_points(temps) do
    cond do
      temps >= 6 -> 7
      true -> 0
    end
  end

  defp refusals_to_points(refusals) do
    case refusals do
      0 -> 0
      1 -> 0
      2 -> -3
      true -> -5
    end
  end
end
