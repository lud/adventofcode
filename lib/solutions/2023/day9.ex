defmodule AdventOfCode.Y23.Day9 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&list_of_ints/1)
  end

  defp list_of_ints(str) do
    str |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&next_num/1)
    |> Enum.sum()
  end

  def next_num([h | t] = list) do
    List.last(list) + _next_num(list)
  end

  defp _next_num([h | t] = list) do
    case diffs(list) do
      {_, true} ->
        0

      {diffs, _} ->
        last = List.last(diffs)
        sub = _next_num(diffs)
        last + sub
    end
  end

  defp diffs([h | t]) do
    {diffs, {_, all_zero?}} =
      Enum.map_reduce(t, {h, _all_zero? = true}, fn next, {prev, all_zero?} ->
        new = next - prev
        {new, {next, all_zero? and new == 0}}
      end)

    {diffs, all_zero?}
  end

  def prev_num([h | t] = list) do
    h - _prev_num(list)
  end

  defp _prev_num([h | t] = list) do
    case diffs(list) do
      {_, true} ->
        0

      {[dh | _] = diffs, _} ->
        sub = _prev_num(diffs)
        dh - sub
    end
  end

  def part_two(problem) do
    problem
    |> Enum.map(&prev_num/1)
    |> Enum.sum()
  end
end
