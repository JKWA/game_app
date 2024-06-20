defmodule GameAppWeb.ConnSetup do
  @moduledoc """
  Module for setting up test connections.
  """
  import GameApp.Factory

  def create_player_1(context) do
    player = insert(:player)
    Map.put(context, :player_1, player)
  end

  def create_player_2(context) do
    player = insert(:player)
    Map.put(context, :player_2, player)
  end
end
