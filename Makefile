up:
	@echo "Creating logs directory..."
	@mkdir -p ./logs
	@echo "Starting up all containers..."
	@docker compose up -d

down:
	@echo "Shutting down all containers..."
	@docker compose down
	@echo "Removing logs directory..."
	@rm -rf ./logs
	@echo "Removing loki-data..."
	@rm -rf ./loki-data

docs:
	@echo "Generating documentation..."
	MIX_ENV=dev mix docs

lint:
	@echo "Linting code..."
	@echo "Running Dializer..."
	MIX_ENV=dev mix dialyzer
	@echo "Running Credo..."
	MIX_ENV=dev mix credo --strict

setup.dev:
	@echo "Getting deps for development environment..."
	MIX_ENV=dev mix deps.get
	@echo "Creating database for development environment..."
	MIX_ENV=dev mix ecto.create
	@echo "Running migrations for development environment..."
	MIX_ENV=dev mix ecto.migrate
	@echo "Adding dialyzer..."
	MIX_ENV=dev mix dialyzer --plt

migrate.dev:
	@echo "Running migrations for development environment..."
	MIX_ENV=dev mix ecto.migrate

serve.dev:
	@echo "Recompiling and running dev server..."
	MIX_ENV=dev mix clean
	MIX_ENV=dev mix compile
	MIX_ENV=dev mix phx.server

reset.dev:
	@echo "Resetting database for development environment..."
	MIX_ENV=dev mix ecto.drop
	@echo "Recreating database for development environment..."
	MIX_ENV=dev mix ecto.create
	@echo "Migrating database for development environment..."
	MIX_ENV=dev mix ecto.migrate

setup.test:
	@echo "Getting deps for test environment..."
	MIX_ENV=test mix deps.get
	@echo "Creating database for testing environment..."
	MIX_ENV=test mix ecto.create
	@echo "Running migrations for testing environment..."
	MIX_ENV=test mix ecto.migrate

reset.test:
	@echo "Resetting database for testing environment..."
	MIX_ENV=test mix ecto.drop
	@echo "Recreating database for testing environment..."
	MIX_ENV=test mix ecto.create
	@echo "Migrating database for testing environment..."
	MIX_ENV=test mix ecto.migrate

setup.integration:
	@echo "Getting deps for integration environment..."
	MIX_ENV=integration mix deps.get
	@echo "Creating database for integration environment..."
	MIX_ENV=integration mix ecto.create
	@echo "Running migrations for integration environment..."
	MIX_ENV=integration mix ecto.migrate

reset.integration:
	@echo "Resetting database for integration environment..."
	MIX_ENV=integration mix ecto.drop
	@echo "Recreating database for integration environment..."
	MIX_ENV=integration mix ecto.create
	@echo "Migrating database for integration environment..."
	MIX_ENV=integration mix ecto.migrate

serve.integration:
	@echo "Recompiling and running integration server..."
	MIX_ENV=integration mix clean
	MIX_ENV=integration mix compile
	MIX_ENV=integration mix phx.server

test.integration:
	@echo "Running Newman tests..."
	@docker-compose run newman

generate.openapi:
	@echo "Generating OpenAPI documentation..."
	MIX_ENV=dev mix openapi.spec.yaml --spec GameAppWeb.ApiSpec


setup.react:
	@echo "Install depedencies for React app..."
	cd ./superheroes-react && npm install

serve.react:
	@echo "Starting React app..."
	cd ./superheroes-react && npm run dev