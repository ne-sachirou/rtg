use Mix.Config

# Configure your database
config :rtg, Rtg.Repo,
  username: "root",
  password: "",
  database: "rtg_dev",
  hostname: "localhost",
  pool_size: 10
