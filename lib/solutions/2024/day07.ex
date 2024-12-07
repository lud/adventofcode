defmodule AdventOfCode.Solutions.Y24.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input, trim: true) |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [result, operation] = String.split(line, ":")

    operands =
      operation
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    {String.to_integer(result), operands}
  end

  def part_one(problem) do
    solve(problem, false)
  end

  def part_two(problem) do
    solve(problem, true)
  end

  defp solve(problem, concat?) do
    problem
    |> Enum.filter(&can_be_computed?(&1, concat?))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp can_be_computed?({result, [h | operands]}, concat?) do
    compute(operands, h, result, concat?)
  end

  defp compute([h], acc, expected, concat?) do
    acc + h == expected ||
      acc * h == expected ||
      (concat? && cat(acc, h) == expected)
  end

  defp compute([h | t], acc, expected, concat?) do
    compute(t, acc + h, expected, concat?) ||
      compute(t, acc * h, expected, concat?) ||
      (concat? && compute(t, cat(acc, h), expected, concat?))
  end

  defp cat(a, b) when b < 10, do: a * 10 + b
  defp cat(a, b) when b < 100, do: a * 100 + b
  defp cat(a, b) when b < 1000, do: a * 1000 + b
end
