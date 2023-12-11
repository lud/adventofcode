defmodule AdventOfCode.Y23.Day11 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Grid.parse_stream(fn
      "." -> :ignore
      "#" -> {:ok, :galaxy}
    end)
    |> Map.keys()
  end

  def part_one(coords) do
    solve(coords, 2)
  end

  def part_two(coords) do
    solve(coords, 1_000_000)
  end

  def solve(coords, expand_value) do
    xa = 0
    ya = 0
    xo = Grid.max_x(coords)
    yo = Grid.max_y(coords)
    empty_xs = xa..xo |> Enum.reject(fn x -> Enum.find(coords, fn {gx, _} -> gx == x end) end)
    empty_ys = ya..yo |> Enum.reject(fn y -> Enum.find(coords, fn {_, gy} -> gy == y end) end)

    coords_list = expand_coords(coords, empty_ys, empty_xs, expand_value)

    count_distances(coords_list, 0)
  end

  defp count_distances([xy_h | t], count) do
    count = Enum.reduce(t, count, fn xy, acc -> acc + manhattan(xy_h, xy) end)
    count_distances(t, count)
  end

  defp count_distances([], count) do
    count
  end

  defp expand_coords(coords, empty_ys, empty_xs, expand_value) do
    expand_value = expand_value - 1
    empty_xs = Enum.sort(empty_xs, :desc)
    empty_ys = Enum.sort(empty_ys, :desc)

    coords = Enum.reduce(empty_xs, coords, fn ex, coords -> expand_x(coords, ex, expand_value) end)
    coords = Enum.reduce(empty_ys, coords, fn ey, coords -> expand_y(coords, ey, expand_value) end)

    coords
  end

  defp expand_x(coords, ex, add) do
    Enum.map(coords, fn
      {x, y} when x > ex -> {x + add, y}
      xy -> xy
    end)
  end

  defp expand_y(coords, ey, add) do
    Enum.map(coords, fn
      {x, y} when y > ey -> {x, y + add}
      xy -> xy
    end)
  end

  defp manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
