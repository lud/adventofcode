defmodule Aoe.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoe,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      cli: cli(),
      modkit: modkit()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3.3"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.6", only: [:dev], runtime: false},
      {:cli_mate, "~> 0.1", runtime: false}
    ]
  end

  defp modkit do
    solutions_mounts =
      for year <- 2015..DateTime.utc_now().year do
        short = year - 2000
        {:"Elixir.Aoe.Y#{short}", "lib/solutions/#{year}"}
      end

    [
      mount: [
        {Aoe, "lib/aoe"},
        {Mix.Tasks, "lib/mix/tasks", flavor: :mix_task}
        | solutions_mounts
      ]
    ]
  end

  def cli do
    [
      preferred_envs: ["aoe.test": :test]
    ]
  end
end
