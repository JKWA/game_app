defmodule GameApp.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias GameApp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GameApp.DataCase
      import GameApp.Factory
    end
  end

  setup tags do
    GameApp.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(GameApp.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end
end
