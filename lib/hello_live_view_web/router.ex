defmodule HelloLiveViewWeb.Router do
  use HelloLiveViewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloLiveViewWeb.Locale
    plug :put_live_layout, {HelloLiveViewWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloLiveViewWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/users/new", UserNew
    live "/users/:id/edit", UserEdit
    live "/users/:id", UserShow
    resources "/users", UserController, only: [:index]
    live "/limit", Limit
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloLiveViewWeb do
  #   pipe_through :api
  # end
end
