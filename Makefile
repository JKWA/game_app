up:
	@echo "Starting up all containers..."
	docker compose up -d

down:
	@echo "Shutting down all containers..."
	docker compose down

docs:
	@echo "Generating documentation..."
	MIX_ENV=dev mix docs

setup.dev:
	@echo "Getting deps for development environment..."
	MIX_ENV=dev mix deps.get
	@echo "Creating database for development environment..."
	MIX_ENV=dev mix ecto.create
	@echo "Running migrations for development environment..."
	MIX_ENV=dev mix ecto.migrate

migrate.dev:
	@echo "Running migrations for development environment..."
	MIX_ENV=dev mix ecto.migrate

serve.dev:
	@echo "Running migrations for development environment..."
	MIX_ENV=dev mix phx.server

reset.dev:
	@echo "Resetting database for development environment..."
	MIX_ENV=dev mix ecto.drop
	@echo "Recreating database for development environment..."
	MIX_ENV=dev mix ecto.create
	@echo "Migrating database for development environment..."
	MIX_ENV=dev mix ecto.migrate
