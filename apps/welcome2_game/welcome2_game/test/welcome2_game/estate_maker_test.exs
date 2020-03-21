defmodule Welcome2Game.EstateMakerTest do
  alias Welcome2Game.{EstateMaker, Tableau}
  use ExUnit.Case, async: true

  describe "#update" do
    test "merges all rows" do
      player_before = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa4number: 4,
        rowa5number: 5,
        rowa6number: 6,
        fencea6: true,
        fenceb3: true,
        rowb4number: 4,
        rowb5number: 5,
        rowb6number: 7,
        fenceb6: true,
        fencec3: true,
        rowc4number: 4,
        rowc5number: 5,
        rowc6number: 7,
        rowc7number: 10,
        fencec7: true
      }

      player_after = EstateMaker.update(player_before)

      assert player_after.built_estates1 == 0
      assert player_after.built_estates2 == 0
      assert player_after.built_estates3 == 3
      assert player_after.built_estates4 == 1
      assert player_after.built_estates5 == 0
      assert player_after.built_estates6 == 0
    end
  end

  describe "#houses_from_player" do
    test "does it" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert EstateMaker.houses_from_player(player, :a, 10) ===
               Enum.reverse([
                 true,
                 true,
                 true,
                 false,
                 true,
                 false,
                 false,
                 false,
                 false,
                 false
               ])
    end
  end

  describe "#fences_from_player" do
    test "does it" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert EstateMaker.fences_from_player(player, :a, 10) ===
               Enum.reverse([
                 false,
                 false,
                 true,
                 false,
                 true,
                 false,
                 false,
                 false,
                 false,
                 true
               ])
    end
  end

  describe "#estates_from_player" do
    test "shows a single estate of size 3" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert EstateMaker.estates_from_player(player, :a) == %{3 => 1}
    end

    test "does not use estate blocks which have been used" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 4,
        rowa5bis: true,
        rowa5plan: true,
        rowa6number: 6,
        rowa6plan: true,
        rowa7number: 8,
        rowa7plan: true,
        rowa8number: 10,
        rowa8plan: true,
        fencea8: true
      }

      assert EstateMaker.estates_from_player(player, :a) == %{4 => 1}
    end

    test "counts multiple estates" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 4,
        rowa5bis: true,
        rowa6number: 6,
        rowa7number: 8,
        rowa8number: 10,
        fencea8: true
      }

      assert EstateMaker.estates_from_player(player, :a) == %{4 => 2}
    end
  end

  describe "#estates_from_row" do
    test "|house|" do
      assert EstateMaker.estates_from_row(
               [true],
               [true]
             ) == [1]
    end

    test "|vacnt|" do
      assert EstateMaker.estates_from_row(
               [false],
               [true]
             ) == [0]
    end

    test "|house house|" do
      assert EstateMaker.estates_from_row(
               [true, true],
               [false, true]
             ) == [10]
    end

    test "|house vacnt|" do
      assert EstateMaker.estates_from_row(
               [true, false],
               [false, true]
             ) == [0]
    end

    test "|vacnt house|" do
      assert EstateMaker.estates_from_row(
               [false, true],
               [false, true]
             ) == [0]
    end

    test "|house house house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house vacnt|house|" do
      assert EstateMaker.estates_from_row(
               [true, false, true],
               [false, true, true]
             ) == [0, 1]
    end

    test "|house|house|" do
      assert EstateMaker.estates_from_row(
               [true, true],
               [true, true]
             ) == [1, 1]
    end

    test "|vacnt|house|" do
      assert EstateMaker.estates_from_row(
               [false, true],
               [true, true]
             ) == [0, 1]
    end

    test "|house|vacnt|" do
      assert EstateMaker.estates_from_row(
               [true, false],
               [true, true]
             ) == [1, 0]
    end

    test "|house house|house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house house house|house house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true, true, true],
               [false, false, true, false, true]
             ) == [100, 10]
    end

    test "|house vacnt house|house house|" do
      assert EstateMaker.estates_from_row(
               [true, false, true, true, true],
               [false, false, true, false, true]
             ) == [0, 10]
    end

    test "|house|house|house|house|house|house|house|house|house|house|house|house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true, true, true, true, true, true, true, true, true, true],
               [true, true, true, true, true, true, true, true, true, true, true, true]
             ) == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    end
  end
end
