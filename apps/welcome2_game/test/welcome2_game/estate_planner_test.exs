defmodule Welcome2Game.EstatePlannerTest do
  alias Welcome2Game.{EstatePlanner, State, Plan, Tableau}
  use ExUnit.Case, async: true

  describe "#update" do
    test "basically it does it" do
      state = %State{
        plan1: %Plan{needs: %{1 => 6}, points1: 10, points2: 5},
        plan2: %Plan{needs: %{2 => 3}, points1: 9, points2: 4},
        plan3: %Plan{needs: %{6 => 2}, points1: 8, points2: 3},
        player: %Tableau{
          built_estates2: 3,
          rowa1number: 1,
          rowa2number: 2,
          fencea2: true,
          rowa3number: 3,
          rowa4number: 4,
          fencea4: true,
          rowa5number: 5,
          rowa6number: 5,
          fencea6: true
        }
      }

      result = EstatePlanner.update(state)

      assert result.plan1_used == false
      assert result.plan2_used == true
      assert result.plan3_used == false
    end
  end

  describe "#satisfy_plan?" do
    test "satisfies positive" do
      state = %State{
        plan1: %Plan{
          needs: %{
            3 => 3,
            4 => 1
          }
        },
        player: %Tableau{
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 3,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert true == EstatePlanner.satisfy_plan?(state, state.plan1)
    end

    test "oversatifies" do
      state = %State{
        plan1: %Plan{
          needs: %{
            1 => 2
          }
        },
        player: %Tableau{
          built_estates1: 4,
          built_estates2: 2,
          built_estates3: 3,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert true == EstatePlanner.satisfy_plan?(state, state.plan1)
    end

    test "unsatisfied" do
      state = %State{
        plan1: %Plan{
          needs: %{
            3 => 3,
            4 => 1
          }
        },
        player: %Tableau{
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert false == EstatePlanner.satisfy_plan?(state, state.plan1)
    end
  end

  describe "#plan_needs" do
    test "returns empty array" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{}})
      assert result == []
    end

    test "returns an array of estate sizes to find" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{4 => 3, 3 => 2, 2 => 1}})
      assert result == [4, 4, 4, 3, 3, 2]
    end

    test "plan of just one type" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{3 => 3}})
      assert result == [3, 3, 3]
    end
  end

  describe "#first_estate_at" do
    test "find the first available estate" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.first_estate_at(%State{player: player}, 1) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 2) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 3) == {:a, 5}
      assert EstatePlanner.first_estate_at(%State{player: player}, 4) == {:a, 1}
      assert EstatePlanner.first_estate_at(%State{player: player}, 5) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 6) == nil
    end
  end

  describe "#estate_exists_at" do
    test "a few found" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.estate_exists_at({:a, 1}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 2}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 3}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 4}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 5}, %State{player: player}, 3) == true
      assert EstatePlanner.estate_exists_at({:a, 6}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 7}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 8}, %State{player: player}, 3) == true
      assert EstatePlanner.estate_exists_at({:a, 9}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 10}, %State{player: player}, 3) == false
    end

    test "none found of too big" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.estate_exists_at({:a, 1}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 2}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 3}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 4}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 5}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 6}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 7}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 8}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 9}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 10}, %State{player: player}, 5) == false
    end
  end

  describe "#with_plan_block_off" do
    test "blocks off a set of slots" do
      state = EstatePlanner.with_plan_block_off(%State{player: %Tableau{}}, 3, :b, 5)

      assert state.player.rowb4plan == false
      assert state.player.rowb5plan == true
      assert state.player.rowb6plan == true
      assert state.player.rowb7plan == true
      assert state.player.rowb8plan == false
    end
  end

  describe "#with_plan" do
    test "removes calculated estate counts" do
      src = %State{
        plan1: %Plan{needs: %{3 => 2}},
        plan2: %Plan{needs: %{4 => 1}},
        plan3: %Plan{needs: %{6 => 1}},
        player: %Tableau{
          fencea1: true,
          rowa2number: 1,
          rowa3number: 2,
          rowa4number: 3,
          rowa5number: 4,
          rowa6number: 5,
          rowa7number: 6,
          fencea7: true,
          rowb1number: 1,
          rowb2number: 2,
          rowb3number: 3,
          rowb4number: 4,
          fenceb4: true,
          rowb5number: 5,
          rowb6number: 6,
          rowb7number: 7,
          rowb8number: 8,
          fenceb8: true,
          rowc1number: 1,
          rowc2number: 2,
          rowc3number: 3,
          fencec3: true,
          rowc4number: 4,
          rowc5number: 5,
          rowc6number: 6,
          fencec6: true,
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 1
        }
      }

      dst = EstatePlanner.with_plan(src, src.plan1, false, 1)

      assert dst.player.built_estates1 == 0
      assert dst.player.built_estates2 == 0
      assert dst.player.built_estates3 == 0
      assert dst.player.built_estates4 == 1
      assert dst.player.built_estates5 == 0
      assert dst.player.built_estates6 == 1
    end

    test "marks slots as used" do
      src = %State{
        plan1: %Plan{needs: %{3 => 2}},
        plan2: %Plan{needs: %{4 => 1}},
        plan3: %Plan{needs: %{6 => 1}},
        player: %Tableau{
          fencea1: true,
          rowa2number: 1,
          rowa3number: 2,
          rowa4number: 3,
          rowa5number: 4,
          rowa6number: 5,
          rowa7number: 6,
          fencea7: true,
          rowb1number: 1,
          rowb2number: 2,
          rowb3number: 3,
          rowb4number: 4,
          fenceb4: true,
          rowb5number: 5,
          rowb6number: 6,
          rowb7number: 7,
          rowb8number: 8,
          fenceb8: true,
          rowc1number: 1,
          rowc2number: 2,
          rowc3number: 3,
          fencec3: true,
          rowc4number: 4,
          rowc5number: 5,
          rowc6number: 6,
          fencec6: true,
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 1
        }
      }

      dst = EstatePlanner.with_plan(src, src.plan1, false, 1)

      assert dst.player.rowc1plan == true
      assert dst.player.rowc2plan == true
      assert dst.player.rowc3plan == true
      assert dst.player.rowc4plan == true
      assert dst.player.rowc5plan == true
      assert dst.player.rowc6plan == true
    end

    test "marks plan as used" do
      src = %State{
        plan1: %Plan{needs: %{3 => 2}},
        plan2: %Plan{needs: %{4 => 1}},
        plan3: %Plan{needs: %{6 => 1}},
        player: %Tableau{
          fencea1: true,
          rowa2number: 1,
          rowa3number: 2,
          rowa4number: 3,
          rowa5number: 4,
          rowa6number: 5,
          rowa7number: 6,
          fencea7: true,
          rowb1number: 1,
          rowb2number: 2,
          rowb3number: 3,
          rowb4number: 4,
          fenceb4: true,
          rowb5number: 5,
          rowb6number: 6,
          rowb7number: 7,
          rowb8number: 8,
          fenceb8: true,
          rowc1number: 1,
          rowc2number: 2,
          rowc3number: 3,
          fencec3: true,
          rowc4number: 4,
          rowc5number: 5,
          rowc6number: 6,
          fencec6: true,
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 1
        }
      }

      dst = EstatePlanner.with_plan(src, src.plan1, false, 1)

      assert dst.plan1_used == true
    end

    test "gives points to player" do
      src = %State{
        plan1: %Plan{needs: %{3 => 2}, points1: 10, points2: 5},
        plan2: %Plan{needs: %{4 => 1}, points1: 9, points2: 4},
        plan3: %Plan{needs: %{6 => 1}, points1: 8, points2: 3},
        player: %Tableau{
          fencea1: true,
          rowa2number: 1,
          rowa3number: 2,
          rowa4number: 3,
          rowa5number: 4,
          rowa6number: 5,
          rowa7number: 6,
          fencea7: true,
          rowb1number: 1,
          rowb2number: 2,
          rowb3number: 3,
          rowb4number: 4,
          fenceb4: true,
          rowb5number: 5,
          rowb6number: 6,
          rowb7number: 7,
          rowb8number: 8,
          fenceb8: true,
          rowc1number: 1,
          rowc2number: 2,
          rowc3number: 3,
          fencec3: true,
          rowc4number: 4,
          rowc5number: 5,
          rowc6number: 6,
          fencec6: true,
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 1
        }
      }

      dst = EstatePlanner.with_plan(src, src.plan1, false, 1)

      assert dst.player.plan1 == 10
    end
  end
end
