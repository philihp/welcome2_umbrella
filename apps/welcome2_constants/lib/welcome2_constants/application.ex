defmodule Welcome2Constants.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Welcome2Constants.Dealer, []),
      worker(Welcome2Constants.Planner, [])
    ]

    options = [name: Welcome2Constants.Supervisor, strategy: :one_for_one]

    Supervisor.start_link(children, options)
  end
end
