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
    Process.sleep(100)
    IO.puts("\n===================")
    List.last(list) + next_num2(list)
  end

  def next_num2([h | t] = list) do
    list |> IO.inspect(label: ~S/list/)

    case next_diff(list) do
      {_, true} ->
        0

      {diffs, _} ->
        last = List.last(diffs)
        sub = next_num2(diffs)
        last |> IO.inspect(label: ~S/last/)
        sub |> IO.inspect(label: ~S/sub/)
        new = last + sub
        new |> IO.inspect(label: ~S/new/)
    end
  end

  defp next_diff([h | t]) do
    {diffs, {_, all_zero?}} =
      Enum.map_reduce(t, {h, _all_zero? = true}, fn next, {prev, all_zero?} ->
        new = next - prev
        {new, {next, all_zero? and new == 0}}
      end)

    {diffs, all_zero?}
  end

  # def part_two(problem) do
  #   problem
  # end
end
