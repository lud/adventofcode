defmodule Mix.Tasks.Aoe.Fetch do
  use Mix.Task

  @shortdoc "Fetch the problem input"

  def run(argv) do
    Application.ensure_all_started(:aoe)

    %{year: year, day: day} = Aoe.Mix.Helpers.parse_year_day(argv)

    case Aoe.Input.ensure_local(year, day) do
      {:ok, path} -> IO.puts("Input #{year}--#{day}: #{path}")
      err -> IO.puts("Error: #{inspect(err)}")
    end
  end
end
