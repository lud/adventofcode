defmodule Aoe.Mix.Helpers do
  require Aoe.Utils

  def parse_year_day(argv) do
    {opts, _, _} =
      OptionParser.parse(argv,
        switches: [year: :integer, day: :integer, part: :integer],
        aliases: [d: :day, y: :year]
      )

    year = Keyword.get(opts, :year, Aoe.Utils.current_year())
    day = Keyword.get(opts, :day, Aoe.Utils.current_day())
    part = Keyword.get(opts, :part, nil)

    validate_year_day(year, day)

    %{year: year, day: day, part: part}
  end

  defp validate_year_day(year, day) when Aoe.Utils.is_valid_day(year, day) do
    :ok
  end

  defp validate_year_day(year, day) do
    Mix.Shell.IO.error("Invalid year/day combination: #{year}/#{day}")
    System.halt(1)
  end
end
