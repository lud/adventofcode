defmodule AdventOfCode.Solutions.Y24.Day18 do
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

    start = {xstart, ystart} |> dbg()
    target = {xend, yend} |> dbg()
    :error = Map.fetch(grid, start)
    :error = Map.fetch(grid, target)

    grid
    |> Map.put(start, ?S)
    |> Map.put(target, ?E)
    |> Grid.print(fn
      :wall -> ?#
      nil -> ?.
      c -> c
    end)

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

  defp in_range({x, y}, min..max//1 = range) do
    x in range && y in range
  end

  def part_two(problem, coord_range \\ 0..70, prefall \\ 1024) do
    already_fell = Enum.take(problem, prefall)
    rest_to_fall = Enum.drop(problem, prefall)
    grid = Map.new(already_fell, fn xy -> {xy, :wall} end)
    xstart..xend//1 = ystart..yend//1 = coord_range
    start = {xstart, ystart} |> dbg()
    target = {xend, yend} |> dbg()

    {x, y} =
      Enum.reduce_while(rest_to_fall, grid, fn new_wall, grid ->
        grid = Map.put(grid, new_wall, :wall)

        case get_cost(grid, start, target, coord_range) do
          {:ok, _} -> {:cont, grid}
          {:error, :no_path} -> {:halt, new_wall}
        end
      end)

    "#{x},#{y}"
  end
end
