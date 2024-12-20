defmodule AdventOfCode.Solutions.Y24.Day08 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    {_grid, _bounds, _meta} =
      input
      |> Input.stream!()
      |> Grid.parse_lines(fn
        _, ?. -> :ignore
        _, ?\n -> raise "parses new line"
        _, c -> {:ok, c}
      end)
  end

  def part_one({grid, bounds, _}) do
    for({xy_l, l} <- grid, {xy_r, r} <- grid, l == r, xy_l < xy_r, do: antinodes_p1(xy_l, xy_r))
    |> :lists.flatten()
    |> Enum.uniq()
    |> Enum.filter(&in_bounds?(&1, bounds))
    |> length()
  end

  defp antinodes_p1({xl, yl}, {xr, yr}) do
    x_diff = xr - xl
    y_diff = yr - yl

    [
      # Lower node
      {xl - x_diff, yl - y_diff},

      # Higher node
      {xr + x_diff, yr + y_diff}
    ]
  end

  defp in_bounds?({x, y}, {xa, xo, ya, yo}) do
    x >= xa and x <= xo and
      y >= ya and y <= yo
  end

  def part_two({grid, bounds, _}) do
    for(
      {xy_l, l} <- grid,
      {xy_r, r} <- grid,
      l == r,
      xy_l < xy_r,
      do: antinodes_p2(xy_l, xy_r, bounds)
    )
    |> :lists.flatten()
    |> Enum.uniq()
    |> length()
  end

  defp antinodes_p2({xl, yl}, {xr, yr}, bounds) do
    x_diff = xr - xl
    y_diff = yr - yl

    higher =
      {xr, yr}
      |> Stream.iterate(fn {x, y} -> {x + x_diff, y + y_diff} end)
      |> Enum.take_while(&in_bounds?(&1, bounds))

    lower =
      {xl, yl}
      |> Stream.iterate(fn {x, y} -> {x - x_diff, y - y_diff} end)
      |> Enum.take_while(&in_bounds?(&1, bounds))

    [higher, lower]
  end
end
