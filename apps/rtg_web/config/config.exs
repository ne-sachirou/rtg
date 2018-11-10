# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rtg_web,
  namespace: RtgWeb,
  ecto_repos: [Rtg.Repo]

# Configures the endpoint
config :rtg_web, RtgWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AqvKjGNt6VfrUw6djMHv70dU4csBJe2oEmO6BdxZCZWth1lVECT6ny7zW5wLvRAD",
  render_errors: [view: RtgWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [
    name: RtgWeb.PubSub,
    adapter: Phoenix.PubSub.RedisZ,
    redis_urls: ["redis://localhost:6379/0"],
    node_name: :"rtg@127.0.0.1"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rtg_web, :generators, context_app: :rtg

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
