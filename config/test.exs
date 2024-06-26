import Config

config :game_app, GameApp.Repo,
  username: "test_user",
  password: "test_password",
  hostname: "localhost",
  port: 5481,
  database: "game_db_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :game_app, GameAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "y/Y/z8ZvjzZwaWhm6KMnGDeVQ8oaAmLmxNkDHSgCRrIUzQ+Vtae6tO6kYOUthcCm",
  server: false

# In test we don't send emails.
config :game_app, GameApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configure the text extract service to use the mock service
config :game_app, text_extract_service: GameApp.External.TextExtractMockService
