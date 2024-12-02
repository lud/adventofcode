defmodule AdventOfCode.Solutions.Y24.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    Enum.map(Input.stream!(input, trim: true), &parse_line/1)
  end

  defp parse_line(line) do
    Enum.map(String.split(line, " "), &String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.filter(&safe?/1)
    |> length()
  end

  defp safe?([a, b | _] = list) when a < b, do: safe?(:asc, list)
  defp safe?([a, b | _] = list) when a > b, do: safe?(:desc, list)
  defp safe?([a, a | _]), do: false

  defp safe?(:asc, [a, b | rest]) when abs(a - b) in 1..3 and a < b, do: safe?(:asc, [b | rest])
  defp safe?(:desc, [a, b | rest]) when abs(a - b) in 1..3 and a > b, do: safe?(:desc, [b | rest])
  defp safe?(_, [_last]), do: true
  defp safe?(_, _), do: false

  def part_two(problem) do
    problem
    |> Enum.filter(&safeish?/1)
    |> length()
  end

  defp safeish?(list) do
    candidates = Stream.concat([list], Stream.map(0..(length(list) - 1), &List.delete_at(list, &1)))
    Enum.any?(candidates, &safe?/1)
  end
end
