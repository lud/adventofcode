defmodule AdventOfCode.Solutions.Y23.Day14 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&String.to_charlist/1)
  end

  def part_one(rows) do
    rows |> rotate() |> tilt() |> score()
  end

  def part_two(rows) do
    cycles_left = 1_000_000_000
    {loop_start, loop_end} = find_loop(rows)

    rows_loop_start = apply_cycles(rows, loop_start)

    cycles_left = cycles_left - loop_start

    diff = loop_end - loop_start
    cycles_left = rem(cycles_left, diff)

    rows_loop_start
    |> apply_cycles(cycles_left)
    |> rotate()
    |> score()
  end

  defp find_loop(init_rows) do
    # trying to find a loop
    cache = %{init_rows => 0}

    Enum.reduce_while(1..9999, {init_rows, cache}, fn n, {rows, cache} ->
      new_rows = cycle(rows)

      case Map.fetch(cache, new_rows) do
        {:ok, same_cycle} -> {:halt, {same_cycle, n}}
        :error -> {:cont, {new_rows, Map.put(cache, new_rows, n)}}
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
    first_col = Enum.map(first_row, fn v -> [v] end)

    Enum.reduce(rest, first_col, fn row, acc ->
      Enum.zip_with(row, acc, fn v, col -> [v | col] end)
    end)
  end

  defp tilt_end([?# | rest]) do
    [?# | tilt_end(rest)]
  end

  defp tilt_end([?. | rest]) do
    [?. | tilt_end(rest)]
  end

  defp tilt_end([?O, ?. | rest]) do
    [?. | tilt_end([?O | rest])]
  end

  defp tilt_end([?O | rest]) do
    case tilt_end(rest) do
      [?. | _] = rest -> tilt_end([?O | rest])
      [?O | _] = rest -> [?O | rest]
      [?# | _] = rest -> [?O | rest]
      [] -> [?O]
    end
  end

  defp tilt_end([]) do
    []
  end

  defp count_score(col) do
    count_score(col, 1, 0)
  end

  defp count_score([?O | rest], row_i, acc) do
    count_score(rest, row_i + 1, acc + row_i)
  end

  defp count_score([_ | rest], row_i, acc) do
    count_score(rest, row_i + 1, acc)
  end

  defp count_score([], _row_i, acc) do
    acc
  end
end
