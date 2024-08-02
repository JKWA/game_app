defmodule GameAppWeb.ApiSpec do
  @moduledoc """
  Module for generating the OpenAPI specification.
  """
  @behaviour OpenApiSpex.OpenApi

  alias OpenApiSpex.{Info, OpenApi, Paths}
  alias GameAppWeb.{Router}

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        %OpenApiSpex.Server{url: "http://localhost:4080"}
      ],
      info: %Info{
        title: "Superheroes API",
        version: "1.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
