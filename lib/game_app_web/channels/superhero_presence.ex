defmodule GameAppWeb.SuperheroPresence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """
  use Phoenix.Presence,
    otp_app: :game_app,
    pubsub_server: GameApp.PubSub
end
