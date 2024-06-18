defmodule GameAppWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint GameAppWeb.Endpoint

      use GameAppWeb, :verified_routes

      alias GameApp.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Plug.Conn
      import Phoenix.ConnTest
      import GameAppWeb.ConnCase
      import GameApp.Factory
      import GameAppWeb.ConnSetup
      import GameAppWeb.HTMLSelectors
    end
  end

  setup tags do
    GameApp.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
