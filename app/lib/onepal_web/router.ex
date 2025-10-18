defmodule OnepalWeb.Router do
  use OnepalWeb, :router

  import OnepalWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OnepalWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: OnepalWeb.ApiSpec
  end

  scope "/", OnepalWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Enable serving swaggerui
  scope "/" do
    # Use the default browser stack
    pipe_through :browser
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  # Other scopes may use custom stacks.
  # scope "/api", OnepalWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:onepal, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OnepalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", OnepalWeb do
    pipe_through [:browser, :require_authenticated_user]

    ## Account region
    live_session :require_authenticated_user,
      on_mount: [{OnepalWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password

    ## Activity region
    get "/activities", ActiviyController, :index
    get "/activities/new", ActiviyController, :new
    get "/activities/:id", ActiviyController, :show
    put "/activities/:id", ActiviyController, :update
    delete "/activities/:id", ActiviyController, :delete
    post "/activities", ActiviyController, :create
    get "/activities/:id/edit", ActiviyController, :edit
  end

  scope "/", OnepalWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{OnepalWeb.UserAuth, :mount_current_scope}] do
      # live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end
end
