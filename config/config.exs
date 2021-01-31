# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :mustrum,
  ecto_repos: [Mustrum.Repo]

config :mustrum_web,
  ecto_repos: [Mustrum.Repo],
  generators: [context_app: :mustrum]

# Configures the endpoint
config :mustrum_web, MustrumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4m8Fxeo0+DwWV1yteJy3QYq1JGYFKy8bZ2vspeZI2vboMkKx+jBNX6G9HSQXZoRi",
  render_errors: [view: MustrumWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mustrum.PubSub,
  live_view: [signing_salt: "NR1Qo6nC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
