defmodule Mustrum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mustrum.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mustrum.PubSub}
      # Start a worker by calling: Mustrum.Worker.start_link(arg)
      # {Mustrum.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Mustrum.Supervisor)
  end
end
