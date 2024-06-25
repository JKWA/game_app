defmodule GameAppWeb.PlayerLive.Index do
  @moduledoc """
  LiveView module for listing players.
  """
  use GameAppWeb, :live_view

  alias GameApp.Accounts
  alias GameApp.Accounts.Player
  alias Phoenix.PubSub

  @update_player_pub_topic "update_player"

  @doc """
  Mount callback for the LiveView.
  #### Overview
  Initializes the LiveView for managing quiz topics, setting up real-time updates and data relevant to the user's session.

  #### Parameters
  - `_params`: Query strings or POST parameters (unused).
  - `_session`: Session data (unused).
  - `socket`: Current LiveView socket.

  #### Functionality
  1. **User and Account Data**:
   - Extracts `account_id` and `user_id` from the socket.

  2. **PubSub Subscriptions**:
   - Subscribes to personalized topics based on `user_id` and `account_id` for receiving real-time updates on questions and topic changes.

  3. **Data Assignment**:
   - Retrieves and assigns topic visibility options and topics accessible to the user.
   - Assigns additional flags like `is_admin` based on user roles for client-side use.

  4. **Socket Updates**:
   - Streams topics to the client and updates the socket with necessary visibility options and statuses.
  """
  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GameApp.PubSub, @update_player_pub_topic)
    players = Accounts.list_players()
    players_map = Map.new(players, fn player -> {player.id, player} end)

    new_socket =
      socket
      |> assign(:deleted_player_ids, MapSet.new())
      |> assign(:players, players_map)
      |> stream(:players, players)

    {:ok, new_socket}
  end

  @doc """
  Handle the LiveView's URL params.
  """
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @doc """
  Handles incoming messages for updating player information in the LiveView.

  This function has three clauses:

  ### Handling `:saved` Message
  #### Overview
  Handles the `:saved` message from the `PlayerLive.FormComponent`, broadcasting an update and maintaining the socket state.

  #### Parameters
  - `{GameAppWeb.PlayerLive.FormComponent, {:saved, player}}`: Tuple indicating the source of the message and the action, along with the player data.
  - `socket`: Current LiveView socket.

  #### Functionality
  - **Broadcast Update**: Sends a broadcast about the updated player using the `broadcast_update/2` function, notifying other parts of the application about the change.
  - **Socket Maintenance**: No changes are made to the socket, and it simply passes through to maintain the current state.

  ### Processing Player Updates
  #### Overview
  Processes updates for players, either adding new ones or updating existing ones, unless the player is marked as deleted.

  #### Parameters
  - `{:update_player, new_player}`: Tuple containing the action and the player data.
  - `socket`: Current LiveView socket.

  #### Functionality
  1. **Check Deletion Status**: Skips updates if the player ID is found in the `deleted_player_ids` set.
  2. **Player Update Handling**:
    - **New Player**: Adds the player to the `players` map and updates the client view if the player does not exist.
    - **Existing Player**: Updates the player data using `get_latest/2` if the player already exists, ensuring only the most recent data is used.
  3. **Stream Updates**:
    - Uses `stream_insert` to send real-time updates to the client, reflecting changes in the player list.

  ### Handling Player Deletion
  #### Overview
  Handles the deletion of a player by updating the application's state and client view accordingly.

  #### Parameters
  - `{:delete_player, player}`: Tuple indicating the action and the player to be deleted.
  - `socket`: Current LiveView socket.

  #### Functionality
  1. **Remove Player**: Deletes the player from the `players` map using the player's ID.
  2. **Track Deletion**: Adds the player's ID to the `deleted_player_ids` set to prevent future operations on this player.
  3. **Update Client View**:
    - Assigns the updated players map and deletion set back to the socket.
    - Initiates a `stream_delete` to remove the player from the client's display in real-time.
  """
  @impl true
  def handle_info({GameAppWeb.PlayerLive.FormComponent, {:saved, player}}, socket) do
    broadcast_update(:update_player, player)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_player, incoming_player}, socket) do
    players = socket.assigns.players
    deleted_player_ids = socket.assigns.deleted_player_ids

    if MapSet.member?(deleted_player_ids, incoming_player.id) do
      {:noreply, socket}
    else
      case Map.get(players, incoming_player.id) do
        nil ->
          updated_players = Map.put(players, incoming_player.id, incoming_player)

          new_socket =
            socket
            |> assign(:players, updated_players)
            |> stream_insert(:players, incoming_player)

          {:noreply, new_socket}

        existing_player ->
          updated_player = get_latest(existing_player, incoming_player)
          updated_players = Map.put(players, incoming_player.id, incoming_player)

          new_socket =
            socket
            |> assign(:players, updated_players)
            |> stream_insert(:players, updated_player)

          {:noreply, new_socket}
      end
    end
  end

  @impl true
  def handle_info({:delete_player, player}, socket) do
    updated_players = Map.delete(socket.assigns.players, player.id)
    deleted_players = MapSet.put(socket.assigns.deleted_player_ids, player.id)

    new_socket =
      socket
      |> assign(:players, updated_players)
      |> assign(:deleted_player_ids, deleted_players)
      |> stream_delete(:players, player)

    {:noreply, new_socket}
  end

  @doc """
  #### Overview
  Handles the "delete" event by attempting to remove a player based on the provided ID, updating the client's interface and internal state as necessary.

  #### Parameters
  - `"delete"`: Event name indicating a deletion request.
  - `%{"id" => id}`: Payload containing the ID of the player to be deleted.
  - `socket`: Current LiveView socket.

  #### Functionality
  1. **Player Retrieval**: Attempts to retrieve the player by ID from the accounts system.
  2. **Deletion Process**:
   - **Successful Player Retrieval**:
     - **Successful Deletion**: If the player is successfully deleted, broadcasts a deletion update and maintains the socket state.
     - **Failed Deletion**: If the deletion fails, displays an error message to the user without altering the socket's assigned data.
     - **Player Not Found**: If no player is found, assumes the player has already been deleted or does not exist and broadcasts a deletion message to ensure UI consistency.
  """
  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Accounts.get_player(id) do
      {:ok, player} ->
        case Accounts.delete_player(player) do
          {:ok, _} ->
            broadcast_update(:delete_player, player)
            {:noreply, socket}

          {:error, reason} ->
            {:noreply, socket |> put_flash(:error, "Could not delete player: #{reason}")}
        end

      {:none} ->
        broadcast_update(:delete_player, %Player{id: id})
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Accounts.get_player(id) do
      {:ok, current_player} ->
        socket
        |> assign(:page_title, "Edit Player")
        |> assign(:player, current_player)

      {:none} ->
        socket
        |> put_flash(:error, "Player not found")
        |> push_redirect(to: "/players")
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, %Player{})
  end

  defp broadcast_update(action, player) do
    Phoenix.PubSub.broadcast(
      GameApp.PubSub,
      @update_player_pub_topic,
      {action, player}
    )
  end

  @spec get_latest(Player.t(), Player.t()) :: Player.t()
  defp get_latest(existing_player, new_player) do
    if NaiveDateTime.compare(existing_player.updated_at, new_player.updated_at) == :gt do
      existing_player
    else
      new_player
    end
  end
end
