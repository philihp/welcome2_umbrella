defmodule Welcome2Game.GameTest do
  alias Welcome2Game.{Game, State, Plan, Tableau}
  use ExUnit.Case, async: true

  test "new_game returns a game" do
    game = Game.new_game()
    assert length(game.deck1) === 26
    assert length(game.deck2) === 26
    assert length(game.deck3) === 26
    assert length(game.shown1) === 1
    assert length(game.shown2) === 1
    assert length(game.shown3) === 1
  end

  test "draw pulls from deck1" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck1 |> length == (game1.deck1 |> length) + 1
  end

  test "draw puts into shown1" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown1 |> length == (game1.shown1 |> length) - 1
  end

  test "draw pulls from deck2" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck2 |> length == (game1.deck2 |> length) + 1
  end

  test "draw puts into shown2" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown2 |> length == (game1.shown2 |> length) - 1
  end

  test "draw pulls from deck3" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck3 |> length == (game1.deck3 |> length) + 1
  end

  test "draw puts into shown3" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown3 |> length == (game1.shown3 |> length) - 1
  end

  test "shuffle regenerates the game" do
    game = Game.new_game() |> Game.draw() |> Game.shuffle()
    assert length(game.deck1) === 26
    assert length(game.deck2) === 26
    assert length(game.deck3) === 26
    assert length(game.shown1) === 1
    assert length(game.shown2) === 1
    assert length(game.shown3) === 1
  end

  test "ends the game" do
    game0 = %State{
      Game.new_game()
      | plan1: %Plan{needs: %{1 => 1}, points1: 10, points2: 1},
        plan2: %Plan{needs: %{2 => 1}, points1: 20, points2: 1},
        plan3: %Plan{needs: %{3 => 1}, points1: 30, points2: 1},
        player: %Tableau{
          plan1: 0,
          plan2: 0,
          plan3: 0,
          rowa1number: 1,
          fencea1: true,
          rowa2number: 2,
          rowa3number: 3,
          fencea3: true,
          rowa4number: 4,
          rowa5number: 5,
          rowa6number: 5,
          fencea6: true
        }
    }

    game1 = Game.commit(game0)
    assert game0.winner == nil
    assert game1.winner == 0
  end
end
