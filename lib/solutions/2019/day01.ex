defmodule AdventOfCode.Solutions.Y19.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Stream.map(&String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.sum_by(&fuel/1)
  end

  def part_two(problem) do
    problem
    |> Enum.sum_by(&recursive_fuel/1)
  end

  defp fuel(n) do
    div(n, 3) - 2
  end

  defp recursive_fuel(n) do
    f = fuel(n)

    if f > 0 do
      f + recursive_fuel(f)
    else
      0
    end
  end
end
