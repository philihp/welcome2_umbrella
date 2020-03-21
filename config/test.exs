use Mix.Config

# Configure your database
config :welcome2_ecto, Welcome2Ecto.Repo,
  username: "postgres",
  password: "postgres",
  database: "welcome2_ecto_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :welcome2_web, Welcome2Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
