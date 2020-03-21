defmodule Welcome2Game.GameEnder do
  alias Welcome2Game.{State, Tableau}

  def update(state) do
    (end_game?(state) && end_game(state)) || state
  end

  def end_game(state) do
    # TODO: calculate score and put it somewhere
    %State{state | winner: 0}
  end

  def end_game?(state) do
    # solo version ends when all decks exhausted
    Enum.any?([
      all_refusals_used?(state.player),
      all_plans_used?(state.player),
      all_slots_used?(state.player),
      deck_too_small(state.deck1),
      deck_too_small(state.deck2),
      deck_too_small(state.deck3)
    ])
  end

  def all_refusals_used?(%Tableau{refusals: refusals}) do
    refusals >= 3
  end

  def all_plans_used?(%Tableau{plan1: plan1, plan2: plan2, plan3: plan3}) do
    plan1 != 0 &&
      plan2 != 0 &&
      plan3 != 0
  end

  def all_slots_used?(player = %Tableau{}) do
    Enum.all?(
      for i <- 1..10 do
        Map.get(player, :"rowa#{i}number") !== nil &&
          Map.get(player, :"rowb#{i}number") !== nil &&
          Map.get(player, :"rowc#{i}number") !== nil
      end
    ) &&
      Map.get(player, :rowb11number) !== nil &&
      Map.get(player, :rowc11number) !== nil &&
      Map.get(player, :rowc12number) !== nil
  end

  defp deck_too_small([_, _ | _]) do
    false
  end

  defp deck_too_small(_) do
    true
  end
end
