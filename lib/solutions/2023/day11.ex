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
    solve(grid, 2)
  end

  def part_two(grid) do
    solve(grid, 1_000_000)
  end

  def solve(grid, expand_value) do
    grid
    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)
    {xo, yo}
    empty_xs = xa..xo |> Enum.reject(fn x -> Enum.find(grid, fn {{gx, _}, _} -> gx == x end) end)
    empty_ys = ya..yo |> Enum.reject(fn y -> Enum.find(grid, fn {{_, gy}, _} -> gy == y end) end)

    grid_list = expand_grid(grid, empty_ys, empty_xs, xo, yo, expand_value)

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

  defp expand_grid(grid, empty_ys, empty_xs, xo, yo, expand_value) do
    expand_value = expand_value - 1
    empty_xs = Enum.sort(empty_xs, :desc)
    empty_ys = Enum.sort(empty_ys, :desc)

    grid =
      grid
      |> Map.to_list()
      |> Enum.sort_by(fn {xy, _} -> xy end, :desc)

    grid = Enum.reduce(empty_xs, grid, fn ex, grid -> expand_x(grid, ex, expand_value) end)
    grid = Enum.reduce(empty_ys, grid, fn ey, grid -> expand_y(grid, ey, expand_value) end)

    # Grid.print_map(Map.new(grid), fn
    #   nil -> "."
    #   :galaxy -> "#"
    # end)

    grid
  end

  defp expand_x(grid, ex, add) do
    Enum.map(grid, fn
      {{x, y}, v} when x > ex -> {{x + add, y}, v}
      {xy, v} -> {xy, v}
    end)
  end

  defp expand_y(grid, ey, add) do
    Enum.map(grid, fn
      {{x, y}, v} when y > ey -> {{x, y + add}, v}
      {xy, v} -> {xy, v}
    end)
  end

  defp manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
