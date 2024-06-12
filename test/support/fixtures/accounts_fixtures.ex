defmodule GameApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameApp.Accounts` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        score: 42
      })
      |> GameApp.Accounts.create_player()

    player
  end
end
