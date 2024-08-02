defmodule GameApp.Factory do
  @moduledoc """
  Module for defining factories for generating test data.
  """
  use ExMachina.Ecto, repo: GameApp.Repo

  alias GameApp.Accounts.Player
  alias GameApp.Superheroes.Superhero

  def player_factory do
    %Player{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      score: Faker.random_between(1, 100_000)
    }
  end

  def superhero_factory do
    %Superhero{
      name: Faker.Superhero.name(),
      location: Faker.Address.city(),
      power: Faker.random_between(1, 100)
    }
  end
end
