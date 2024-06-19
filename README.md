# Learning Elixir

This project is an educational resource designed to facilitate learning and understanding the core concepts of Elixir.

## Getting Started

### Prerequisites

Before starting, ensure you have the following software installed on your machine:

- [Phoenix Framework](https://hexdocs.pm/phoenix/installation.html)
- [Docker and Docker Compose](https://docs.docker.com/)
- [Make](https://sp21.datastructur.es/materials/guides/make-install.html)

### Installation

To get started with the project, clone the repository and navigate to the directory:

```bash
git clone https://github.com/JKWA/game_app
cd game_app
```

### Docker Container Management

#### Starting All Containers

Start all Docker containers using the following command:

```bash
make up
```

This command initiates all containers in detached mode.

#### Shutting Down All Containers

Stop all containers by running:

```bash
make down
```

### Development Commands

#### Setting Up the Development Environment

Setup your development environment, including dependencies and database, with:

```bash
make setup.dev
```

#### Running the Development Server

To launch the Phoenix server for development:

```bash
make serve.dev
```

#### Resetting the Development Database

Reset the development database (drop, create, migrate) using:

```bash
make reset.dev
```

### Additional Makefile Commands

- **Generating Documentation**: Run `make docs` to generate project documentation.
- **Analyzing Development Code**: Use `make analyze.dev` to perform static code analysis.
- **Migrating Development Database**: Execute `make migrate.dev` to run database migrations.
- **Setting Up Test Environment**: Prepare the test environment using `make setup.test`.
- **Resetting Test Database**: Reset the test database with `make reset.test`.
