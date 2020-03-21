defmodule Welcome2Ecto.Repo do
  use Ecto.Repo,
    otp_app: :welcome2_ecto,
    adapter: Ecto.Adapters.Postgres
end
