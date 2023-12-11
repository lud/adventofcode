defmodule AdventOfCode.Y23.Day11 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    AoC.Grid.parse_stream(input, fn
      "." -> :ignore
      "#" -> {:ok, :galaxy}
    end)
  end

  def part_one(grid) do
    grid
    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)
    {xo, yo}
    empty_xs = xa..xo |> Enum.reject(fn x -> Enum.find(grid, fn {{gx, _}, _} -> gx == x end) end)
    empty_ys = ya..yo |> Enum.reject(fn y -> Enum.find(grid, fn {{_, gy}, _} -> gy == y end) end)

    grid_list = expand_grid(grid, empty_ys, empty_xs, xo, yo)

    count_distances(grid_list, 0)
  end

  defp count_distances([h | t], count) do
    {xy_h, _} = h
    count = Enum.reduce(t, count, fn {xy, _}, acc -> acc + manhattan(xy_h, xy) end)
    count_distances(t, count)
  end

  defp count_distances([], count) do
    count
  end

  defp expand_grid(grid, empty_ys, empty_xs, xo, yo) do
    empty_xs = Enum.sort(empty_xs, :desc)
    empty_ys = Enum.sort(empty_ys, :desc)

    grid =
      grid
      |> Map.to_list()
      |> Enum.sort_by(fn {xy, _} -> xy end, :desc)

    grid = Enum.reduce(empty_xs, grid, fn ex, grid -> expand_x(grid, ex) end)
    grid = Enum.reduce(empty_ys, grid, fn ey, grid -> expand_y(grid, ey) end)

    grid
  end

  defp expand_x(grid, ex) do
    Enum.map(grid, fn
      {{x, y}, v} when x > ex -> {{x + 1, y}, v}
      {xy, v} -> {xy, v}
    end)
  end

  defp expand_y(grid, ey) do
    Enum.map(grid, fn
      {{x, y}, v} when y > ey -> {{x, y + 1}, v}
      {xy, v} -> {xy, v}
    end)
  end

  defp manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  # def part_two(problem) do
  #   problem
  # end
end
