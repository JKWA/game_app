defmodule GameAppWeb.PlayerLive.FormComponent do
  @moduledoc """
  LiveView module for adding a new player and editing an player's details.
  """

  use GameAppWeb, :live_component

  alias GameApp.Accounts
  alias GameApp.Accounts.Player
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage player records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="player-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:score]} type="number" label="Score" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Player</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{player: player} = assigns, socket) do
    changeset = Player.update_changeset(player)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"player" => player_params}, socket) do
    changeset =
      socket.assigns.player
      |> Player.update_changeset(player_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    save_player(socket, socket.assigns.action, player_params)
  end

  defp save_player(socket, :edit, player_params) do
    case Accounts.update_player(socket.assigns.player, player_params) do
      {:ok, player} ->
        notify_parent({:saved, player})

        socket
        |> put_flash(:info, "Player updated successfully")
        |> push_patch(to: socket.assigns.patch)
        |> respond(:noreply)

      {:none} ->
        {:noreply,
         socket
         |> put_flash(:error, "Player not found")
         |> push_redirect(to: "/players")}

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
        |> respond(:noreply)
    end
  end

  defp save_player(socket, :new, player_params) do
    case Accounts.create_player(player_params) do
      {:ok, player} ->
        notify_parent({:saved, player})

        {:noreply,
         socket
         |> put_flash(:info, "Player created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp respond(socket, response_type), do: {response_type, socket}

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
