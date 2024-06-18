defmodule GameApp.Factory do
  use ExMachina.Ecto, repo: GameApp.Repo

  alias GameApp.Accounts.Player

  def player_factory do
    %Player{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      score: Faker.random_between(1, 100_000)
    }
  end
end
