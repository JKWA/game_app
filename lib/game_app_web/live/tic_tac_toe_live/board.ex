defmodule GameAppWeb.TicTacToeLive.Board do
  use GameAppWeb, :live_component
  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.header>
        Tic Tac Toe (<%= assigns.game_server %>-server)
        <:subtitle>
          <%= case assigns.game_state.game_status do %>
            <% :ongoing -> %>
              Current turn: <%= Atom.to_string(assigns.game_state.current_player) |> String.upcase() %>
            <% :win -> %>
              Winner: <%= Atom.to_string(assigns.game_state.current_player) |> String.upcase() %>
            <% :tie -> %>
              Game ended in a tie.
          <% end %>
        </:subtitle>
        <:actions>
          <%= if assigns.game_state.game_status != :ongoing do %>
            <.button phx-click="reset">
              Reset Game
            </.button>
          <% end %>
          <.button phx-click="crash">
            Crash Game
          </.button>
        </:actions>
      </.header>

      <div class="mt-6 grid grid-cols-3 gap-4">
        <%= for {key, value} <- Map.to_list(assigns.game_state.board) do %>
          <.button
            class={button_class(assigns, key)}
            disabled={assigns.game_state.game_status != :ongoing}
            phx-click="mark"
            phx-value-position={key}
          >
            <%= if value, do: Atom.to_string(value) |> String.upcase(), else: "-" %>
          </.button>
        <% end %>
      </div>
    </section>
    """
  end

  @doc false
  def button_class(assigns, key) do
    is_winner = is_list(assigns.game_state.win) && Enum.member?(assigns.game_state.win, key)

    base_class = "h-32 text-3xl "
    winner_class = if is_winner, do: "bg-green-400 hover:bg-green-400", else: ""

    base_class <> winner_class
  end
end
