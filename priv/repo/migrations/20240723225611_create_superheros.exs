defmodule GameApp.Repo.Migrations.CreateSuperheroes do
  use Ecto.Migration

  def up do
    create table(:superheroes) do
      add :name, :string
      add :location, :string
      add :power, :integer

      timestamps()
    end
  end

  def down do
    drop table(:superheroes)
  end
end
