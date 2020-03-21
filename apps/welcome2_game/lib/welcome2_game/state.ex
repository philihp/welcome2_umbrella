defmodule Welcome2Game.State do
  use Gex.State

  alias Welcome2Game.{Game, State, Tableau, MoveFinder, GameScorer}

  defstruct(
    state: :setup,
    winner: nil,
    moves: [],
    history: [],
    current_move: [],
    checkpoint: nil,
    plan1: nil,
    plan2: nil,
    plan3: nil,
    plan1_used: false,
    plan2_used: false,
    plan3_used: false,
    deck1: [],
    deck2: [],
    deck3: [],
    shown1: [],
    shown2: [],
    shown3: [],
    permit: nil,
    built: nil,
    effect: nil,
    player: %Tableau{}
  )

  def score(state = %State{}) do
    GameScorer.score(state)
  end

  def terminal?(%State{winner: winner}) do
    winner != nil
  end

  def winner(%State{winner: winner}) do
    winner
  end

  def active_player(%State{}) do
    0
  end

  def advance(src_state, :draw) do
    Game.draw(src_state)
  end

  def advance(src_state, :shuffle) do
    Game.shuffle(src_state)
  end

  def advance(src_state, {:permit, index}) do
    Game.permit(src_state, index)
  end

  def advance(src_state, {:build, row, index}) do
    Game.build(src_state, row, index)
  end

  def advance(src_state, :pool) do
    Game.pool(src_state)
  end

  def advance(src_state, {:agent, size}) do
    Game.agent(src_state, size)
  end

  def advance(src_state, :park) do
    Game.park(src_state)
  end

  def advance(src_state, {:fence, row, index}) do
    Game.fence(src_state, row, index)
  end

  def advance(src_state, {:bis, row, index, offset}) do
    Game.bis(src_state, row, index, offset)
  end

  def advance(src_state, {:temp, row, index, offset}) do
    Game.temp(src_state, row, index, offset)
  end

  def advance(src_state, :commit) do
    Game.commit(src_state)
  end

  def advance(src_state, :refuse) do
    Game.refuse(src_state)
  end

  def advance(src_state, :rollback) do
    Game.rollback(src_state)
  end

  def view(src_state) do
    Game.view(src_state)
  end

  def actions(state = %State{}) do
    MoveFinder.moves(state)
  end

  def feature_vector(%State{}) do
    [0.0, 0.0, 0.0]
  end
end
