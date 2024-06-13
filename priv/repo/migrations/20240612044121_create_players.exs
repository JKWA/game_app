defmodule GameApp.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def up do
    create table(:players) do
      add :name, :string
      add :email, :string, null: false
      add :score, :integer

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:players, [:email])
  end

  def down do
    drop_if_exists unique_index(:players, [:email])
    drop table(:players)
  end
end
