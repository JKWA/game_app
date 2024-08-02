import Config

config :game_app, GameApp.Repo,
  username: "integration_user",
  password: "integration_password",
  hostname: "localhost",
  port: 5483,
  database: "game_db_integration",
  pool_size: 10

config :game_app, GameAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  secret_key_base: "y/Y/z8ZvjzZwaWhm6KMnGDeVQ8oaAmLmxNkDHSgCRrIUzQ+Vtae6tO6kYOUthcCm",
  server: true

config :game_app, GameApp.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false

config :logger, level: :info

config :logger,
  backends: [:console]

config :phoenix, :plug_init_mode, :runtime

config :game_app, text_extract_service: GameApp.External.TextExtractMockService

config :game_app, Oban, testing: :inline
