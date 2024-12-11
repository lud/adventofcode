defmodule AdventOfCode.Solutions.Y24.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    solve(problem, 25)
  end

  def part_two(problem) do
    solve(problem, 75)
  end

  defp solve(problem, cycles) do
    stones = build_stones(problem)
    stones = Enum.reduce(1..cycles, stones, fn _, stones -> blink_all(stones) end)
    Enum.reduce(stones, 0, fn {_, c}, acc -> acc + c end)
  end

  defp build_stones(figures) do
    Enum.reduce(figures, %{}, fn k, map -> merge_stone(map, k, 1) end)
  end

  defp merge_stone(map, k, n) do
    Map.update(map, k, n, &(&1 + n))
  end

  defp blink_all(stones) do
    stones
    |> Enum.flat_map(&blink/1)
    |> Enum.reduce(%{}, fn {k, n}, map -> merge_stone(map, k, n) end)
  end

  defp blink({0, count}), do: [{1, count}]

  defp blink({figure, count}) do
    case memoized_blink(figure) do
      {left, right} -> [{left, count}, {right, count}]
      by_2024 -> [{by_2024, count}]
    end
  end

  defp memoized_blink(figure) do
    case Process.get({__MODULE__, figure}, nil) do
      nil ->
        result = blink_figure(figure)
        Process.put({__MODULE__, figure}, result)
        result

      result ->
        result
    end
  end

  defp blink_figure(figure) do
    digits = Integer.digits(figure)
    len = length(digits)

    if rem(len, 2) == 0 do
      {left, right} = Enum.split(digits, div(len, 2))

      {Integer.undigits(left), Integer.undigits(right)}
    else
      figure * 2024
    end
  end
end
