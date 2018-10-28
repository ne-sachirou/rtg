use Mix.Config

# Configure your database
config :rtg, Rtg.Repo,
  username: "root",
  password: "",
  database: "rtg_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
