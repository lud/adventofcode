defmodule AdventOfCode.Y23.Day18 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [dir, n, _color] = String.split(line, " ")

    dir =
      case dir do
        "R" -> :e
        "L" -> :w
        "U" -> :n
        "D" -> :s
      end

    n = String.to_integer(n)
    {dir, n}
  end

  def part_one(problem) do
    {_, grid, rows} =
      problem
      |> Enum.reduce({{0, 0}, %{}, %{}}, &dig/2)

    AoC.Grid.print_map(grid, fn
      true -> "#"
      nil -> "."
    end)

    rows
    |> Enum.map(&count_row/1)
    |> Enum.sum()
  end

  defp count_row({y, xs}) do
    y |> IO.inspect(label: ~S/y/)
    xs = Enum.sort(xs) |> dbg()
    count_zones(xs, 0)
  end

  defp count_zones(xs, count) do
    {left, [right | _] = xs, count} = consume_start(xs, count) |> dbg()
    {xs, count} = consume_end(xs, count)
    count_zones(xs, count)
  end

  defp consume_start([x1, x2 | xs], count) when x1 + 1 == x2 do
    consume_start([x2 | xs], count + 1)
  end

  defp consume_start([x], count) do
    {x, [], count + 1}
  end

  defp consume_start([x1, x2 | xs], count) when x1 + 1 == x2 do
    consume_start([x2 | xs], count + 1)
  end

  defp consume_end([x1, x2 | xs], count) when x1 + 1 == x2 do
    consume_end([x2 | xs], count + 1)
  end

  defp consume_end([], count) do
    {[], count}
  end

  defp dig({_dir, 0}, {pos, grid, rows}) do
    {pos, grid, rows}
  end

  defp dig({dir, n}, {{x, y} = pos, grid, rows}) do
    pos = AoC.Grid.translate(pos, dir)
    grid = Map.put(grid, pos, true)
    rows = Map.update(rows, y, [x], &[x | &1])
    dig({dir, n - 1}, {pos, grid, rows})
  end

  # def part_two(problem) do
  #   problem
  # end
end
