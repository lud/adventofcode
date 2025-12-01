defmodule AdventOfCode.Solutions.Y25.Day01 do
  alias AoC.Input

  def parse(input, :part_one) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn
      "R" <> n -> {:right, String.to_integer(n)}
      "L" <> n -> {:left, String.to_integer(n)}
    end)
  end

  def parse(input, :part_two) do
    input
    |> Input.stream!(trim: true)
    |> Enum.flat_map(fn
      "R" <> n -> expand_rotation(:right, String.to_integer(n))
      "L" <> n -> expand_rotation(:left, String.to_integer(n))
    end)
  end

  defp expand_rotation(direction, amount) when amount <= 100 do
    [{direction, amount}]
  end

  defp expand_rotation(direction, amount) when amount > 100 do
    [{direction, 100} | expand_rotation(direction, amount - 100)]
  end

  def part_one(problem) do
    problem
    |> Stream.scan(50, fn
      {:left, n}, acc -> Integer.mod(acc - n, 100)
      {:right, n}, acc -> Integer.mod(acc + n, 100)
    end)
    |> Enum.count(&(&1 == 0))
  end

  def part_two(problem) do
    problem
    |> Stream.transform(50, fn
      {:left, n}, acc ->
        new_acc = Integer.mod(acc - n, 100)
        {[{:left, acc, new_acc}], new_acc}

      {:right, n}, acc ->
        new_acc = Integer.mod(acc + n, 100)
        {[{:right, acc, new_acc}], new_acc}
    end)
    |> Enum.count(fn
      {_, _, 0} -> true
      {_, 0, _} -> false
      {:right, a, b} when a > b -> true
      {:left, a, b} when a < b -> true
      {_, same, same} -> true
      _ -> false
    end)
  end
end
