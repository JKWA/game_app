defmodule GameAppWeb.SuperheroController do
  use GameAppWeb, :controller
  use OpenApiSpex.ControllerSpecs
  require Logger

  alias GameApp.Superheroes
  alias GameApp.Superheroes.Superhero
  alias GameAppWeb.Schemas.{SuperheroRequest, SuperheroResponse, SuperheroesResponse}

  @update_superhero_pub_topic "update_superhero"

  def topic do
    @update_superhero_pub_topic
  end

  action_fallback GameAppWeb.FallbackController

  operation(:index,
    summary: "List superheroes",
    responses: [
      ok: {"Superheroes", "application/json", SuperheroesResponse}
    ]
  )

  def index(conn, _params) do
    superheroes = Superheroes.list_superheroes()
    render(conn, :index, superheroes: superheroes)
  end

  operation(:create,
    summary: "Create a superhero",
    request_body: {"SuperheroRequest", "application/json", SuperheroRequest},
    responses: [
      created: {"SuperheroResponse", "application/json", SuperheroResponse}
    ]
  )

  def create(conn, %{"superhero" => superhero_params}) do
    with {:ok, %Superhero{} = superhero} <- Superheroes.create_superhero(superhero_params) do
      broadcast_update(:create, superhero)

      conn
      |> put_status(:created)
      |> render(:show, superhero: superhero)
    end
  end

  operation(:show,
    summary: "Show a superhero",
    parameters: [
      id: [
        in: :path,
        description: "ID of the superhero",
        required: true,
        schema: %OpenApiSpex.Schema{type: :integer}
      ]
    ],
    responses: [
      ok: {"SuperheroResponse", "application/json", SuperheroResponse}
    ]
  )

  def show(conn, %{"id" => id}) do
    superhero = Superheroes.get_superhero!(id)
    render(conn, :show, superhero: superhero)
  end

  operation(:update,
    summary: "Update a superhero",
    parameters: [
      id: [
        in: :path,
        description: "ID of the superhero",
        required: true,
        schema: %OpenApiSpex.Schema{type: :integer}
      ]
    ],
    request_body: {"SuperheroRequest", "application/json", SuperheroRequest},
    responses: [
      ok: {"SuperheroResponse", "application/json", SuperheroResponse}
    ]
  )

  def update(conn, %{"id" => id, "superhero" => superhero_params}) do
    superhero = Superheroes.get_superhero!(id)

    with {:ok, %Superhero{} = superhero} <-
           Superheroes.update_superhero(superhero, superhero_params) do
      broadcast_update(:update, superhero)
      render(conn, :show, superhero: superhero)
    end
  end

  operation(:delete,
    summary: "Delete a superhero",
    parameters: [
      id: [
        in: :path,
        description: "ID of the superhero",
        required: true,
        schema: %OpenApiSpex.Schema{type: :integer}
      ]
    ],
    responses: [
      no_content: {"No content", "application/json", nil}
    ]
  )

  def delete(conn, %{"id" => id}) do
    superhero = Superheroes.get_superhero!(id)

    with {:ok, %Superhero{}} <- Superheroes.delete_superhero(superhero) do
      broadcast_update(:delete, superhero)

      send_resp(conn, :no_content, "")
    end
  end

  defp broadcast_update(action, superhero) do
    Logger.debug("Broadcasting #{action} for superhero #{superhero.id}")

    Phoenix.PubSub.broadcast(
      GameApp.PubSub,
      @update_superhero_pub_topic,
      {action, superhero}
    )
  end
end
