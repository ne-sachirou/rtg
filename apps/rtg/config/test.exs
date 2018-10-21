use Mix.Config

# Configure your database
config :rtg, Rtg.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "rtg_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
