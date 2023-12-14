defmodule AdventOfCode.Y23.Day14 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&String.graphemes/1)
  end

  def part_one(rows) do
    rows |> rotate() |> tilt() |> score()
  end

  def part_two(rows) do
    left_cycles = 1_000_000_000
    # left_cycles = 20
    {loop_start, loop_end} = find_loop(rows) |> dbg()
    rows_loop_start = apply_cycles(rows, loop_start)
    rows_loop_start |> print()

    left_cycles = (left_cycles - loop_start) |> dbg()
    diff = (loop_end - loop_start) |> dbg()
    left_cycles = rem(left_cycles, diff) |> dbg()

    end_rows = apply_cycles(rows_loop_start, left_cycles)

    end_rows |> rotate() |> score()

    # faked = apply_cycles(rows, 20) |> print() |> score() |> dbg()
  end

  defp find_loop(init_rows) do
    # trying to find a loop
    cache = %{init_rows => 0}

    Enum.reduce_while(1..1_000_000_000, {init_rows, cache}, fn n, {rows, cache} ->
      IO.puts("Cycle #{Integer.to_string(n)}")
      new_rows = cycle(rows)

      case Map.fetch(cache, new_rows) do
        {:ok, same_cycle} ->
          print(new_rows)
          {:halt, {same_cycle, n}}

        :error ->
          new_rows |> rotate() |> score() |> IO.inspect(label: "Score at #{n}")
          {:cont, {new_rows, Map.put(cache, new_rows, n)}}
      end
    end)
  end

  defp apply_cycles(rows, 0) do
    rows
  end

  defp apply_cycles(rows, n) when n > 0 do
    rows |> cycle() |> apply_cycles(n - 1)
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

  defp score(rows) do
    rows |> Enum.map(&count_score/1) |> Enum.sum()
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
