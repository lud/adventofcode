defmodule AdventOfCode.Solutions.Y25.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [ranges, ids] = input |> Input.read!() |> String.split("\n\n")
    ranges = ranges |> lines() |> Enum.map(&parse_range/1)
    ids = ids |> lines() |> Enum.map(&String.to_integer/1)
    {ranges, ids}
  end

  defp lines(text), do: String.split(text, "\n", trim: true)

  defp parse_range(str) do
    [a, b] = String.split(str, "-")
    String.to_integer(a)..String.to_integer(b)
  end

  def part_one({ranges, ids}) do
    Enum.count(ids, fn id -> Enum.any?(ranges, &(id in &1)) end)
  end

  def part_two({ranges, _}) do
    ranges
    |> Enum.sort_by(fn a..b//_ -> {a, b} end)
    |> reduce_ranges()
    |> Enum.sum_by(&Range.size/1)
  end

  defp reduce_ranges([a..b//_, c..d//_ | rest]) when c > b do
    [a..b | reduce_ranges([c..d | rest])]
  end

  defp reduce_ranges([a..b//s, c..d//_ | rest]) when c in a..b//s do
    reduce_ranges([a..max(b, d) | rest])
  end

  defp reduce_ranges([last]) do
    [last]
  end
end
