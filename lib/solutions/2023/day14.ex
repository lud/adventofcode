defmodule AdventOfCode.Y23.Day14 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&String.graphemes/1)
  end

  def part_one(rows) do
    rows |> rotate() |> tilt() |> Enum.map(&count_score/1) |> Enum.sum()
  end

  def part_two(init_rows) do
    Enum.reduce(1_000_000_000..1//-1, init_rows, fn n, rows ->
      if rem(n, 1000) == 0 do
        IO.puts("Cycle #{Integer.to_string(n)}")
      end

      cycle(rows)
    end)
    |> print()
    |> Enum.map(&count_score/1)
    |> Enum.sum()
  end

  defp cycle(rows) do
    rows
    # north
    |> rotate()
    |> tilt()
    # west
    |> rotate()
    |> tilt()
    # south
    |> rotate()
    |> tilt()
    # east
    |> rotate()
    |> tilt()
  end

  defp tilt(rows) do
    Enum.map(rows, &tilt_end/1)
  end

  defp rotate([first_row | rest]) do
    first_col =
      Enum.map(first_row, fn v -> [v] end)

    Enum.reduce(rest, first_col, fn row, acc ->
      Enum.zip_with(row, acc, fn v, col -> [v | col] end)
    end)
  end

  defp tilt_end(["#" | rest]) do
    ["#" | tilt_end(rest)]
  end

  defp tilt_end(["." | rest]) do
    ["." | tilt_end(rest)]
  end

  defp tilt_end(["O", "." | rest]) do
    ["." | tilt_end(["O" | rest])]
  end

  defp tilt_end(["O" | rest]) do
    case tilt_end(rest) do
      ["." | _] = rest -> tilt_end(["O" | rest])
      ["O" | _] = rest -> ["O" | rest]
      ["#" | _] = rest -> ["O" | rest]
      [] -> ["O"]
    end
  end

  defp tilt_end([]) do
    []
  end

  defp count_score(col) do
    count_score(col, 1, 0)
  end

  defp count_score(["O" | rest], row_i, acc) do
    count_score(rest, row_i + 1, acc + row_i)
  end

  defp count_score([_ | rest], row_i, acc) do
    count_score(rest, row_i + 1, acc)
  end

  defp count_score([], _row_i, acc) do
    acc
  end

  defp print(map) do
    ["==========\n" | Enum.intersperse(map, "\n")] |> IO.puts()
    map
  end
end
