ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GameApp.Repo, :manual)
Faker.start()
Mox.defmock(GameApp.External.TextExtractMockService, for: GameApp.External.TextExtractBehaviour)
