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
    y |> IO.inspect(label: ~S/====================== y/)
    [h | t] = xs = Enum.sort(xs)

    count =
      Enum.reduce(t, {h, [[h]]}, fn
        x, {prev, [acc | accs]} when x == prev + 1 -> {x, [[x | acc] | accs]}
        x, {prev, [acc | accs]} -> {x, [[x], acc | accs]}
      end)
      |> elem(1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn
        [end_bound, start_bound] ->
          [start | tstart] = start_bound
          count = length(tstart)
          [xend | _] = end_bound
          count = count + (xend - start) + 1
          start_bound |> IO.inspect(label: ~S/start_bound/)
          end_bound |> IO.inspect(label: ~S/end_bound/)
          count

        [single_acc] ->
          length(single_acc)
      end)
      |> Enum.sum()

    count |> IO.inspect(label: ~S/count/)
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
