defmodule GameApp.Repo.Migrations.AddOban do
  use Ecto.Migration

  def up, do: Oban.Migrations.up(version: 11)

  def down, do: Oban.Migrations.down(version: 11)
end
