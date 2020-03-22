defmodule Welcome2Web.Router do
  use Welcome2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/game", Welcome2Web do
    pipe_through :browser

    get "/", GameController, :index
    post "/", GameController, :new
    put "/", GameController, :advance
  end

  # Other scopes may use custom stacks.
  # scope "/api", Welcome2Web do
  #   pipe_through :api
  # end
end
