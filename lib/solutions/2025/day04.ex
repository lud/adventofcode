defmodule AdventOfCode.Solutions.Y25.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    lines = Input.stream!(input, trim: true)

    for {row, y} <- Enum.with_index(lines),
        {"@", x} <- Enum.with_index(String.graphemes(row)),
        reduce: %{},
        do: (grid -> Map.put(grid, {x, y}, true))
  end

  def part_one(grid) do
    map_size(accessibles(grid))
  end

  def part_two(grid) do
    clear_grid = loop_remove(grid)
    map_size(grid) - map_size(clear_grid)
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
