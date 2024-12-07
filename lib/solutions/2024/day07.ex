defmodule AdventOfCode.Solutions.Y24.Day07 do
  alias AdventOfCode.Combinations
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
    problem
    |> Enum.filter(&can_be_computed?/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp can_be_computed?({result, operands}) do
    operators_combins = Combinations.of([:+, :*], length(operands) - 1)
    Enum.any?(operators_combins, fn c -> result == compute(operands, c) end)
  end

  defp compute([h | operands], operators) do
    Enum.reduce(Enum.zip(operators, operands), h, fn
      {:+, n}, acc -> acc + n
      {:*, n}, acc -> acc * n
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
