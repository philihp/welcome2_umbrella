defmodule Welcome2Game do
  def new_game do
    {:ok, pid} = Supervisor.start_child(Welcome2Game.Supervisor, [])
    pid
  end

  def make_move(pid, move) do
    GenServer.call(pid, move)
  end
end
