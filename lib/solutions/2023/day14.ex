defmodule AdventOfCode.Y23.Day14 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.to_list()
  end

  def part_one(problem) do
    problem |> to_columns() |> Enum.map(&tilt_end/1) |> Enum.map(&count_score/1) |> Enum.sum()
  end

  defp to_columns([first_row | rest]) do
    first_col =
      first_row
      |> String.graphemes()
      |> Enum.map(fn v -> [v] end)

    Enum.reduce(rest, first_col, fn row, acc ->
      row |> String.graphemes() |> Enum.zip_with(acc, fn v, col -> [v | col] end)
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

  # def part_two(problem) do
  #   problem
  # end
end
