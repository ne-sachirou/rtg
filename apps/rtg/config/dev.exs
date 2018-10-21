use Mix.Config

# Configure your database
config :rtg, Rtg.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "rtg_dev",
  hostname: "localhost",
  pool_size: 10
