defmodule Welcome2Game.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Welcome2Game.Server, [])
    ]

    options = [
      name: Welcome2Game.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
