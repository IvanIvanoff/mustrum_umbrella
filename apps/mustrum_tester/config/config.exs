# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :mustrum_tester, MustrumTesterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C+ZvlVrTJVdJKfkBIE0UZz5cVW6WKe6Rknz+FYGuFn3em3S5e3BwBcjEgsDtXgbQ",
  render_errors: [view: MustrumTesterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MustrumTester.PubSub,
  live_view: [signing_salt: "wLIUVTvx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
