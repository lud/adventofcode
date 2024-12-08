defmodule AdventOfCode.Solutions.Y24.Day08 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    {_grid, _bounds} =
      input
      |> Input.stream!()
      |> Grid.parse_lines(fn
        _, ?. -> :ignore
        _, ?\n -> raise "parses new line"
        _, c -> {:ok, <<c>>}
      end)
      |> dbg()
  end

  def part_one({grid, bounds}) do
    for {xy_l, l} <- grid,
        {xy_r, r} <- grid,
        l == r,
        xy_l < xy_r do
      {node_l, node_r} = antinodes(xy_l, xy_r)
      [node_l, node_r]
    end
    |> :lists.flatten()
    |> Enum.uniq()
    |> Enum.filter(&in_bounds?(&1, bounds))
    |> length()
  end

  defp antinodes({xl, yl}, {xr, yr}) do
    IO.puts("------------")
    {xl, yl} |> IO.inspect(label: "{xl, yl}")
    {xr, yr} |> IO.inspect(label: "{xr, yr}")
    x_diff = xr - xl
    y_diff = yr - yl

    {
      # Lower node
      {xl - x_diff, yl - y_diff},

      # Higher node
      {xr + x_diff, yr + y_diff}
    }
    |> dbg()
  end

  defp in_bounds?({x, y}, {xa, xo, ya, yo}) do
    x >= xa and x <= xo and
      y >= ya and y <= yo
  end

  # def part_two(problem) do
  #   problem
  # end
end
