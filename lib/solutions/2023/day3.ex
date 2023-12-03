defmodule AdventOfCode.Y23.Day3 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    AoC.Grid.parse_stream(input, &parse_char/1)
  end

  defp parse_char(<<n>>) when n in ?0..?9, do: {:ok, n - ?0}
  defp parse_char(<<?.>>), do: :ignore
  defp parse_char(<<_>>), do: {:ok, :sym}

  def part_one(grid) do
    adjacent_digits =
      grid
      |> Enum.filter(fn {xy, val} -> val in 0..9 and sym_neighbour?(grid, xy) end)
      |> Enum.map(fn {xy, _} -> first_digit(grid, xy) end)
      |> Enum.uniq()
      |> Enum.map(&collect_number(grid, &1))
      |> Enum.sum()
  end

  defp sym_neighbour?(grid, xy) do
    c8s = xy |> AoC.Grid.cardinal8() |> Enum.any?(fn txy -> Map.get(grid, txy) == :sym end)
  end

  defp first_digit(grid, xy) do
    west_xy = AoC.Grid.translate(xy, :w)

    case Map.get(grid, west_xy) do
      n when is_integer(n) -> first_digit(grid, west_xy)
      _ -> xy
    end
  end

  defp collect_number(grid, xy) do
    collect_number(grid, xy, [Map.fetch!(grid, xy)])
  end

  defp collect_number(grid, xy, acc) do
    east_xy = AoC.Grid.translate(xy, :e)

    case Map.get(grid, east_xy) do
      n when is_integer(n) -> collect_number(grid, east_xy, [n | acc])
      _ -> acc |> :lists.reverse() |> Integer.undigits()
    end
  end

  def part_two(problem) do
    problem
  end
end
