defmodule GameAppWeb.PlayerLive.Show do
  @moduledoc """
  LiveView module for displaying and player details.
  """

  use GameAppWeb, :live_view

  alias GameApp.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @doc """
  Handles parameter changes to the player ID, fetching the player data.
  """
  def handle_params(%{"id" => id}, _, socket) do
    case Accounts.get_player(id) do
      {:ok, player} ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:player, player)}

      {:none} ->
        {:noreply,
         socket
         |> put_flash(:error, "Player not found")
         |> push_redirect(to: "/players")}
    end
  end

  defp page_title(:show), do: "Show Player"
  defp page_title(:edit), do: "Edit Player"
end
