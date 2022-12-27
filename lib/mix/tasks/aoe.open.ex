defmodule Mix.Tasks.Aoe.Open do
  alias Aoe.CliTool
  use Mix.Task

  @shortdoc "Open the problem page"

  def run(argv) do
    Application.ensure_all_started(:aoe)

    %{options: options} = CliTool.parse_or_halt!(argv, CliTool.year_day_command(__MODULE__))
    %{year: year, day: day} = CliTool.validate_options!(options)

    System.cmd("xdg-open", ["https://adventofcode.com/#{year}/day/#{day}"])
  end
end
