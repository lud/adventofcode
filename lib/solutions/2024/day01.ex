defmodule AdventOfCode.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.unzip()
  end

  defp parse_line(line) do
    [a, b] = String.split(line, " ", trim: true)
    {a, ""} = Integer.parse(a)
    {b, ""} = Integer.parse(b)
    {a, b}
  end

  def part_one(problem) do
    {left, right} = problem
    left = Enum.sort(left)
    right = Enum.sort(right)
    Enum.zip_with(left, right, fn a, b -> abs(a - b) end) |> Enum.sum()
  end

  def part_two(problem) do
    {left, right} = problem
    freqs = Enum.frequencies(right)
    left |> Enum.map(fn a -> a * Map.get(freqs, a, 0) end) |> Enum.sum()
  end
end
