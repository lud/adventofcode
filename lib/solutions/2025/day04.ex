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
    map_size(accessibles(grid))
  end

  def part_two(grid) do
    new_grid = loop_remove(grid)
    map_size(grid) - map_size(new_grid)
  end

  defp loop_remove(grid) do
    case Map.drop(grid, Map.keys(accessibles(grid))) do
      ^grid -> grid
      new_grid -> loop_remove(new_grid)
    end
  end

  defp accessibles(grid) do
    Map.filter(grid, &less_than_four_neighbors?(&1, grid))
  end

  defp less_than_four_neighbors?({{x, y}, _}, grid) do
    for(nx <- (x - 1)..(x + 1), ny <- (y - 1)..(y + 1), {nx, ny} != {x, y}, do: {nx, ny})
    |> Enum.count(&Map.has_key?(grid, &1))
    |> Kernel.<(4)
  end
end
