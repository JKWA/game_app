# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :game_app,
  ecto_repos: [GameApp.Repo]

# Configures the endpoint
config :game_app, GameAppWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: GameAppWeb.ErrorHTML, json: GameAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GameApp.PubSub,
  live_view: [signing_salt: "AvcP/hIv"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :game_app, GameApp.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger

common_metadata = [
  :request_id,
  :trace_id,
  :span_id,
  :parent_span_id,
  :start_time,
  :end_time,
  :job_name,
  :worker,
  :attempt,
  :max_attempts,
  :queue,
  :status,
  :duration
]

config :logger, :file,
  path: "logs/prod.log",
  format: {GameApp.LoggerFormatter, :format},
  metadata: common_metadata,
  level: :info

config :logger,
  backends: [{LoggerFileBackend, :file}]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the TextExtractService
config :game_app, text_extract_service: GameApp.External.TextExtractProdService

# Configures Oban
config :game_app, Oban,
  repo: GameApp.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, long_jobs: 5]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
