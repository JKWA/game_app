defmodule GameApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias GameApp.Games.TicTacToe
  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GameAppWeb.Telemetry,
      # Start the Ecto repository
      GameApp.Repo,
      # Start the Oban supervisor
      {Oban, Application.fetch_env!(:game_app, Oban)},
      # Start the PubSub system
      {Phoenix.PubSub, name: GameApp.PubSub},
      # Start Finch
      {Finch, name: GameApp.Finch},

      # Start Global TicTacToe
      {TicTacToe.WithAgent, name: TicTacToe.WithAgent},

      # Start the TicTacToe Registry
      {Registry, keys: :unique, name: GameApp.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: GameApp.DynamicSupervisor},
      TicTacToe.Registry,

      # Start the Endpoint (http/https)
      GameAppWeb.Endpoint
      # Start a worker by calling: GameApp.Worker.start_link(arg)
      # {GameApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GameAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
