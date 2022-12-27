defmodule Aoe.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoe,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
    [
      mount: [
        {Aoe, "lib/aoe"},
        {Aoe.Y20, "lib/solutions/2020"},
        {Aoe.Y21, "lib/solutions/2021"},
        {Aoe.Y22, "lib/solutions/2022"}
      ]
    ]
  end
end
