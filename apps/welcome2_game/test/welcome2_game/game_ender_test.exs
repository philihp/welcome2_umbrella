defmodule Welcome2Game.GameEnderTest do
  alias Welcome2Game.{Game, GameEnder, State, Tableau}
  use ExUnit.Case, async: true

  describe "#update" do
    test "ends game when all refusals used" do
      state = %State{
        Game.new_game()
        | player: %Tableau{
            refusals: 3
          }
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == 0
    end

    test "does not end when only 2 refusals used" do
      state = %State{
        Game.new_game()
        | player: %Tableau{
            refusals: 2
          }
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == nil
    end

    test "does not end if not all plans used" do
      state = %State{
        Game.new_game()
        | player: %Tableau{
            plan1: 1,
            plan3: 1
          }
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == nil
    end

    test "ends game when all plans used" do
      state = %State{
        Game.new_game()
        | player: %Tableau{
            plan1: 1,
            plan2: 1,
            plan3: 1
          }
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == 0
    end

    test "does not end game when player has open slots" do
      state = %State{
        Game.new_game()
        | player: %Tableau{}
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == nil
    end

    test "ends game when all slots taken" do
      state = %State{
        Game.new_game()
        | player: %Tableau{
            rowa1number: 1,
            rowa2number: 1,
            rowa3number: 1,
            rowa4number: 1,
            rowa5number: 1,
            rowa6number: 1,
            rowa7number: 1,
            rowa8number: 1,
            rowa9number: 1,
            rowa10number: 1,
            rowb1number: 1,
            rowb2number: 1,
            rowb3number: 1,
            rowb4number: 1,
            rowb5number: 1,
            rowb6number: 1,
            rowb7number: 1,
            rowb8number: 1,
            rowb9number: 1,
            rowb10number: 1,
            rowb11number: 1,
            rowc1number: 1,
            rowc2number: 1,
            rowc3number: 1,
            rowc4number: 1,
            rowc5number: 1,
            rowc6number: 1,
            rowc7number: 1,
            rowc8number: 1,
            rowc9number: 1,
            rowc10number: 1,
            rowc11number: 1,
            rowc12number: 1
          }
      }

      result = GameEnder.update(state)

      assert state.winner == nil
      assert result.winner == 0
    end
  end
end
