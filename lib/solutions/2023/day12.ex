defmodule AdventOfCode.Y23.Day12 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    Enum.map(input, &parse_line/1)
  end

  defp parse_line(line) do
    [sources, counts] = String.split(line, " ")
    sources = String.to_charlist(sources)
    counts = counts |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    {sources, counts}
  end

  def part_one(problem) do
    problem
    |> Enum.map(&count_line/1)
  end

  def count_line({sources, counts} = line) do
    line |> IO.inspect(label: ~S/line/)
    len = length(sources)
    # we know the groups of contiguous broken sources we want the groups of the
    # valid sources. They are at least one in between each broken group, and maybe 0 or more before the groups and after the groups
    [1 | ones] = contiguous = Enum.map(counts, fn _ -> 1 end)
    ok_sources_base = [0 | ones] ++ [0]

    max_ok_group = length(ok_sources_base) - 1

    # now for each broken source, we add 1 to each of the ok groups, givig more
    # and more combinations
    n_distrib = Enum.count(sources, &(&1 == ??))

    Enum.reduce(1..n_distrib, [ok_sources_base], fn _, ok_sources_groups ->
      Enum.flat_map(ok_sources_groups, fn group ->
        Enum.map(0..max_ok_group, fn i -> List.update_at(group, i, &(&1 + 1)) end)
      end)
    end)
    |> Enum.count()
    |> dbg()
  end

  # def part_two(problem) do
  #   problem
  # end
end
