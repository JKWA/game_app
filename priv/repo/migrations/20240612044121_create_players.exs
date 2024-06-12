defmodule GameApp.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :email, :string
      add :score, :integer

      timestamps(type: :naive_datetime_usec)
    end
  end
end
