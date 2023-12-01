defmodule Mix.Tasks.Aoe.Test do
  alias Aoe.CliTool
  use Mix.Task

  @shortdoc "Runs the tests for a given year and day"

  def run(argv) do
    Application.ensure_all_started(:aoe)
    %{options: options} = CliTool.parse_or_halt!(argv, CliTool.year_day_command(__MODULE__))
    %{year: year, day: day} = CliTool.validate_options!(options)

    Mix.Task.run("test", ["test/#{year}/day#{day}_test.exs"])
  end
end
