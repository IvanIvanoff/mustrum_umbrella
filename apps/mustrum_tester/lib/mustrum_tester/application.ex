defmodule MustrumTester.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env() == :prod do
      Envy.auto_load()
    end

    children = [
      # Start the Telemetry supervisor
      MustrumTesterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MustrumTester.PubSub},
      # Start the Endpoint (http/https)
      MustrumTesterWeb.Endpoint
      # Start a worker by calling: MustrumTester.Worker.start_link(arg)
      # {MustrumTester.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MustrumTester.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MustrumTesterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
