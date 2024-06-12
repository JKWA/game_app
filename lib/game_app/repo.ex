defmodule GameApp.Repo do
  use Ecto.Repo,
    otp_app: :game_app,
    adapter: Ecto.Adapters.Postgres
end
