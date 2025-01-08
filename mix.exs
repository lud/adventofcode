defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
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
      {:nvir, "~> 0.9.4"},
      {:aoc, "0.14.0"},
      # {:aoc, path: "../aoc"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.7", only: [:dev], runtime: false}
    ]
  end

  defp modkit do
    solutions_mounts =
      for year <- 2015..DateTime.utc_now().year do
        short = year - 2000
        {:"Elixir.AdventOfCode.Solutions.Y#{short}", "lib/solutions/#{year}"}
      end

    [
      mount: [{AdventOfCode, "lib/advent_of_code"} | solutions_mounts]
    ]
  end

  def cli do
    [
      preferred_envs: ["aoc.test": :test]
    ]
  end
end
