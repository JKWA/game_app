defmodule GameAppWeb.Router do
  use GameAppWeb, :router

  @swagger_ui_config [
    path: "/api/openapi",
    default_model_expand_depth: 3,
    display_operation_id: true,
    csp_nonce_assign_key: %{script: :script_src_nonce, style: :style_src_nonce}
  ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GameAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: GameAppWeb.ApiSpec
  end

  scope "/", GameAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/players", PlayerLive.Index, :index
    live "/players/new", PlayerLive.Index, :new
    live "/players/:id/edit", PlayerLive.Index, :edit

    live "/players/:id", PlayerLive.Show, :show
    live "/players/:id/show/edit", PlayerLive.Show, :edit

    live "/get-text", GetTextLive.Index, :index

    live "/increment", IncrementLive.Index, :index

    live "/long-job", LongJobLive.Index, :index

    live "/tic-tac-toe", TicTacToeLive.WithAgent, :index

    live "/tic-tac-toe/:server", TicTacToeLive.GenServer, :index
  end

  scope "/api" do
    pipe_through :api

    resources "/superheroes", GameAppWeb.SuperheroController, except: [:new, :edit]
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/" do
    pipe_through :browser

    get "/docs", OpenApiSpex.Plug.SwaggerUI, @swagger_ui_config
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:game_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GameAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
