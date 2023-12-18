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

    print(grid)

    # This may not work with any input. We are searching for "#.#", and in my
    # input and the exemple input, the dot is inside, so we can fill from there.
    fill_xy = find_fill_start(rows)

    grid = fill_map([fill_xy], grid)
    map_size(grid)
  end

  defp print(grid) do
    AoC.Grid.print_map(grid, fn
      true -> "#"
      nil -> "."
    end)
  end

  defp fill_map([h | open], grid) do
    neighs =
      h
      |> AoC.Grid.cardinal4()
      |> Enum.reject(fn xy -> Map.has_key?(grid, xy) end)

    grid = Map.put(grid, h, true)
    open = neighs ++ open
    fill_map(open, grid)
  end

  defp fill_map([], grid) do
    grid
  end

  defp find_fill_start(rows) do
    Enum.find_value(rows, fn {y, row} ->
      case find_one_gap(Enum.sort(row)) do
        nil -> nil
        x -> {x + 1, y}
      end
    end)
  end

  defp find_one_gap([xa, xb | rest]) when xa + 2 == xb do
    xa
  end

  defp find_one_gap([xa | rest]) do
    find_one_gap(rest)
  end

  defp find_one_gap([]) do
    nil
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
