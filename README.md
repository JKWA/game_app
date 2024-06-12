# Learning Elixir

This project is designed for teaching and learning about Elixir, focusing on fundamental Elixir concepts.

## Getting Started

### Prerequisites

Ensure you have the following installed:

- Elixir
- Phoenix Framework
- Docker

### Installation

Clone the repository to your local machine and navigate to the project directory:

```bash
git clone https://github.com/JKWA/game_app
cd game_app
```

#### Starting All Containers

To start all Docker containers, run:

```bash
make up
```

#### Shutting Down All Containers

To stop all containers, run:

```bash
make down
```

### Development Commands

#### Setting Up the Development Environment

To set up with dependencies and database, run:

```bash
make setup.dev
```

#### Running the Development Server

To start the Phoenix server, run:

```bash
make serve.dev
```

#### Resetting the Development Database

To reset the database (drop, create, migrate), run:

```bash
make reset.dev
```
