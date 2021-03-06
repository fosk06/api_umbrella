defmodule Person.MixProject do
  use Mix.Project

  def project do
    [
      app: :person,
      version: "1.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger,:timex],
      mod: {Person.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:db_connector, in_umbrella: true},
      {:uuid, "~> 1.1"},
      {:timex, "~> 3.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:faker, "~> 0.12.0"}
    ]
  end
end
