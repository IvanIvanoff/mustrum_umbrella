defmodule MustrumTesterWeb.Router do
  use MustrumTesterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MustrumTesterWeb do
    pipe_through :api
  end
end
