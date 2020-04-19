defmodule Welcome2Ecto.Repo.Migrations.CreateState do
  use Ecto.Migration

  def change do
    create table(:state) do
      add :state, :string
    end
  end
end
