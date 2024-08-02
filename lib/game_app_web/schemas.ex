defmodule GameAppWeb.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Superhero do
    OpenApiSpex.schema(%{
      title: "Superhero",
      description: "A superhero in the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Superhero ID"},
        name: %Schema{type: :string, description: "Superhero name"},
        location: %Schema{type: :string, description: "Superhero location"},
        power: %Schema{
          type: :integer,
          description: "Superhero power level",
          minimum: 1,
          maximum: 100,
          example: 75
        }
      },
      required: [:name, :location, :power],
      example: %{
        "id" => 1,
        "name" => "Superman",
        "location" => "Metropolis",
        "power" => 100
      }
    })
  end

  defmodule SuperheroRequest do
    OpenApiSpex.schema(%{
      title: "SuperheroRequest",
      description: "POST body for creating a superhero",
      type: :object,
      properties: %{
        superhero: %Schema{anyOf: [Superhero]}
      },
      required: [:superhero],
      example: %{
        "superhero" => %{
          "name" => "Superman",
          "location" => "Metropolis",
          "power" => 100
        }
      }
    })
  end

  defmodule SuperheroResponse do
    OpenApiSpex.schema(%{
      title: "SuperheroResponse",
      description: "Response schema for single superhero",
      type: :object,
      properties: %{
        data: Superhero
      },
      example: %{
        "data" => %{
          "id" => 1,
          "name" => "Superman",
          "location" => "Metropolis",
          "power" => 100
        }
      }
    })
  end

  defmodule SuperheroesResponse do
    OpenApiSpex.schema(%{
      title: "SuperheroesResponse",
      description: "Response schema for multiple superheroes",
      type: :object,
      properties: %{
        data: %Schema{description: "The superheroes details", type: :array, items: Superhero}
      },
      example: %{
        "data" => [
          %{
            "id" => 1,
            "name" => "Superman",
            "location" => "Metropolis",
            "power" => 100
          },
          %{
            "id" => 2,
            "name" => "Batman",
            "location" => "Gotham",
            "power" => 90
          }
        ]
      }
    })
  end
end
