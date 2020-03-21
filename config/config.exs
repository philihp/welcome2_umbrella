# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :welcome2_ecto,
  ecto_repos: [Welcome2Ecto.Repo]



config :welcome2_web,
  generators: [context_app: :welcome2]

# Configures the endpoint
config :welcome2_web, Welcome2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hPeIweqI/t0LIsXH6JKMp8w0tbxJ7/ucBc/wSIJGd1BMhNcAg/3QM5FOLE1JYlxC",
  render_errors: [view: Welcome2Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Welcome2Web.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
