defmodule AdventOfCode.Solutions.Y24.Day18 do
  alias AdventOfCode.BinarySearch
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    {x, "," <> rest} = Integer.parse(line)
    {y, ""} = Integer.parse(rest)
    {x, y}
  end

  def part_one(problem, coord_range \\ 0..70, prefall \\ 1024) do
    grid = problem |> Enum.take(prefall) |> Map.new(fn xy -> {xy, :wall} end)
    xstart..xend//1 = ystart..yend//1 = coord_range

    start = {xstart, ystart}
    target = {xend, yend}
    :error = Map.fetch(grid, start)
    :error = Map.fetch(grid, target)

    {:ok, cost} = get_cost(grid, start, target, coord_range)

    cost
  end

  defp get_cost(grid, start, target, coord_range) do
    Grid.bfs_path(grid, start, target, fn xy, grid ->
      xy
      |> Grid.cardinal4()
      |> Enum.filter(&(in_range(&1, coord_range) && :error == Map.fetch(grid, &1)))
    end)
  end

  defp in_range({x, y}, range) do
    x in range && y in range
  end

  def part_two(problem, coord_range \\ 0..70, prefall \\ 1024) do
    already_fell = Enum.take(problem, prefall)
    rest_to_fall = Enum.drop(problem, prefall)

    base_grid = Map.new(already_fell, fn xy -> {xy, :wall} end)

    xstart..xend//1 = ystart..yend//1 = coord_range
    start = {xstart, ystart}
    target = {xend, yend}

    try_wall = fn n_walls ->
      new_walls =
        rest_to_fall
        |> Enum.take(n_walls)
        |> Map.new(fn xy -> {xy, :wall} end)

      grid = Map.merge(base_grid, new_walls)

      case get_cost(grid, start, target, coord_range) do
        {:ok, _} -> :lt
        {:error, :no_path} -> :gt
      end
    end

    {:error, {:tie, min, _}} = BinarySearch.search(try_wall, 1, length(rest_to_fall))
    {x, y} = Enum.at(rest_to_fall, min)
    "#{x},#{y}"
  end
end
