defmodule Welcome2Game.Game do
  alias Welcome2Game.{
    Card,
    Plan,
    State,
    Tableau,
    MoveFinder,
    EstateMaker,
    EstatePlanner,
    GameEnder
  }

  use Gex.Game

  def default_state() do
    Welcome2Game.Game.new_game()
  end

  def random_state() do
    Welcome2Game.Game.new_game()
  end

  def new_game do
    deck =
      Welcome2Constants.deck()
      |> Poison.decode!(as: [%Card{}])
      |> Enum.shuffle()

    [plan1, plan2, plan3] =
      Enum.map(
        Welcome2Constants.plans(),
        fn json ->
          Poison.decode!(json, as: [%Welcome2Game.Plan{}])
          |> Enum.shuffle()
          |> hd
          |> Plan.clean_needs()
        end
      )

    size = deck |> length |> div(3)

    %State{
      state: :playing,
      plan1: plan1,
      plan2: plan2,
      plan3: plan3,
      deck1: deck |> Enum.slice(0 * size, size),
      deck2: deck |> Enum.slice(1 * size, size),
      deck3: deck |> Enum.slice(2 * size, size),
      shown1: [],
      shown2: [],
      shown3: [],
      player: %Tableau{}
    }
    |> draw
  end

  def draw(state) do
    %{
      deck1: [drawn_card1 | remainder_deck1],
      deck2: [drawn_card2 | remainder_deck2],
      deck3: [drawn_card3 | remainder_deck3],
      shown1: shown1,
      shown2: shown2,
      shown3: shown3
    } =
      cond do
        # commented out, because end of game should usually occur if the decks are empty
        # length(state.deck1) <= 1 -> shuffle(state)
        true -> state
      end

    %State{
      state
      | deck1: remainder_deck1,
        deck2: remainder_deck2,
        deck3: remainder_deck3,
        shown1: [drawn_card1 | shown1],
        shown2: [drawn_card2 | shown2],
        shown3: [drawn_card3 | shown3]
    }
  end

  def shuffle(state) do
    deck =
      (state.deck1 ++ state.shown1 ++ state.deck2 ++ state.shown2 ++ state.deck3 ++ state.shown3)
      |> Enum.shuffle()

    len = deck |> length
    size = div(len, 3)

    %State{
      state
      | deck1: deck |> Enum.slice(0 * size, size),
        deck2: deck |> Enum.slice(1 * size, size),
        deck3: deck |> Enum.slice(2 * size, size),
        shown1: [],
        shown2: [],
        shown3: []
    }
    |> draw
  end

  def permit(state, number) do
    %State{
      state
      | permit: state |> Map.get(:"shown#{number}") |> hd,
        checkpoint: state.checkpoint || state,
        current_move: [{:permit, number} | state.current_move]
    }
  end

  def refuse(state) do
    %State{
      state
      | player: struct(state.player, %{refusals: state.player.refusals + 1}),
        permit: :refused,
        checkpoint: state.checkpoint || state,
        current_move: [:refuse | state.current_move]
    }
  end

  def build(state, row, index) do
    %State{
      state
      | player: struct(state.player, %{:"row#{row}#{index}number" => state.permit.face}),
        built: {row, index},
        current_move: [{:build, row, index} | state.current_move]
    }
  end

  def pool(state = %{built: {row, index}}) do
    effect = :pool

    %State{
      state
      | player:
          struct(state.player, %{
            :pools => state.player.pools + 1,
            :"row#{row}#{index}pool" => true
          }),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def agent(state, size) do
    effect = {:agent, size}
    old_value = state.player |> Map.get(:"estate#{size}")
    new_value = MoveFinder.next_estate(size, old_value) || old_value

    %State{
      state
      | player: struct(state.player, %{:"estate#{size}" => new_value}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def park(state = %{built: {row, _}}) do
    effect = :park

    old_value = Map.get(state.player, :"park#{row}")
    new_value = MoveFinder.next_park(row, old_value)

    %State{
      state
      | player: struct(state.player, %{:"park#{row}" => new_value}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def fence(state, row, index) do
    effect = {:fence, row, index}

    %State{
      state
      | player: struct(state.player, %{:"fence#{row}#{index}" => true}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def bis(state, row, index, offset) do
    effect = {:bis, row, index, offset}

    %State{
      state
      | player:
          struct(state.player, %{
            :"row#{row}#{index}bis" => true,
            :bis => state.player.bis + 1,
            :"row#{row}#{index}number" =>
              Map.get(state.player, :"row#{row}#{index + offset}number")
          }),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def temp(state, row, index, offset) do
    effect = {:temp, row, index, offset}

    %State{
      state
      | player:
          struct(state.player, %{
            :"row#{row}#{index}number" => state.permit.face + offset,
            :temps => state.player.temps + 1
          }),
        built: {row, index},
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def commit(state) do
    %State{
      state
      | permit: nil,
        built: nil,
        effect: nil,
        moves: state.current_move ++ [:commit] ++ state.moves,
        current_move: [],
        checkpoint: nil
    }
    |> EstateMaker.update()
    |> EstatePlanner.update()
    |> GameEnder.update()
    |> draw
  end

  def rollback(state) do
    state.checkpoint
  end

  def view(state) do
    %{
      winner: state.winner,
      player: state.player |> Map.from_struct(),
      plan1: state.plan1,
      plan2: state.plan2,
      plan3: state.plan3,
      plan1_used: state.plan1_used,
      plan2_used: state.plan2_used,
      plan3_used: state.plan3_used,
      deck1_suit: state.deck1 |> top |> Map.get(:suit),
      deck2_suit: state.deck2 |> top |> Map.get(:suit),
      deck3_suit: state.deck3 |> top |> Map.get(:suit),
      deck1_length: state.deck1 |> length,
      deck2_length: state.deck2 |> length,
      deck3_length: state.deck3 |> length,
      shown1: state.shown1 |> top,
      shown2: state.shown2 |> top,
      shown3: state.shown3 |> top,
      state: state.state,
      permit: state.permit,
      built: state.built,
      moves: MoveFinder.moves(state)
    }
  end

  defp top([]) do
    nil
  end

  defp top(list) do
    list |> hd
  end
end
