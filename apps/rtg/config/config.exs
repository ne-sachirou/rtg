use Mix.Config

config :rtg, ecto_repos: [Rtg.Repo]

import_config "#{Mix.env()}.exs"
