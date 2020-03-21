defmodule Welcome2Game.Server do
  alias Welcome2Game.{Game, State}
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call({}, _from, state) do
    {:reply, Game.view(state), state}
  end

  def handle_call(action, _from, src_state) do
    dst_state = State.advance(src_state, action)
    {:reply, Game.view(dst_state), dst_state}
  end
end
