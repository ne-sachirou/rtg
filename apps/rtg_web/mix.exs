defmodule RtgWeb.Mixfile do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :rtg_web,
      build_path: "../../_build",
      compilers: [:phoenix, :gettext] ++ Mix.compilers() ++ [:elixir_script],
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.7",
      elixir_script: [input: RtgWeb.Js],
      elixirc_paths: elixirc_paths(Mix.env()),
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      version: "0.0.1"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RtgWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:elixir_script, "~> 0.32"},
      {:elixir_script_web, "~> 0.2"},
      {:gettext, "~> 0.16"},
      {:phoenix, "~> 1.4"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.12"},
      {:phoenix_live_reload, "~> 1.1", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_pubsub_redis_z, "~> 0.2"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:rtg, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
