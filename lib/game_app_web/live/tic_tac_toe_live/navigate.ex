defmodule GameAppWeb.TicTacToeLive.Navigate do
  use GameAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <navigate class="text-gray-600 p-3 rounded-md flex space-x-4 justify-center items-center">
      <.link
        navigate={~p"/tic-tac-toe"}
        class="hover:bg-gray-200 px-3 py-2 rounded-md transition-colors duration-300"
      >
        Global
      </.link>
      <.link
        navigate={~p"/tic-tac-toe/tic"}
        class="hover:bg-gray-200 px-3 py-2 rounded-md transition-colors duration-300"
      >
        Tic
      </.link>
      <.link
        navigate={~p"/tic-tac-toe/tac"}
        class="hover:bg-gray-200 px-3 py-2 rounded-md transition-colors duration-300"
      >
        Tac
      </.link>
      <.link
        navigate={~p"/tic-tac-toe/toe"}
        class="hover:bg-gray-200 px-3 py-2 rounded-md transition-colors duration-300"
      >
        Toe
      </.link>
    </navigate>
    """
  end
end
