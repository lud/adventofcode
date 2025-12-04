defmodule AdventOfCode.Solutions.Y25.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {"@", x}, acc -> Map.put(acc, {x, y}, :roll)
        _, acc -> acc
      end)
    end)
  end

  def part_one(grid) do
    Enum.count(grid, &less_than_four_neighbors?(&1, grid))
  end

  defp less_than_four_neighbors?({{x, y}, :roll}, grid) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        {nx, ny} != {x, y} do
      (Map.has_key?(grid, {nx, ny}) && 1) || 0
    end
    |> Enum.sum()
    |> Kernel.<(4)
  end

  # def part_two(problem) do
  #   problem
  # end
end
