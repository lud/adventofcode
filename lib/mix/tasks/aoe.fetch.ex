defmodule Mix.Tasks.Aoe.Fetch do
  alias Aoe.CliTool
  use Mix.Task

  @shortdoc "Fetch the problem input"

  def run(argv) do
    Application.ensure_all_started(:aoe)

    %{options: options} = CliTool.parse_or_halt!(argv, CliTool.year_day_command(__MODULE__))
    %{year: year, day: day} = CliTool.validate_options!(options)

    case Aoe.Input.ensure_local(year, day) do
      {:ok, path} -> IO.puts("Input #{year}--#{day}: #{path}")
      err -> IO.puts("Error: #{inspect(err)}")
    end
  end
end
