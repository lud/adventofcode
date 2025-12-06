defmodule AdventOfCode.Solutions.Y25.Day06 do
  alias AoC.Input

  # No separate parsing today :)
  def parse(input, _), do: input

  def part_one(input) do
    input
    |> Input.stream!(trim: true)
    |> Stream.map(&String.split(&1, " ", trim: true))
    |> Enum.zip_with(& &1)
    |> Enum.sum_by(fn list ->
      {op, args} = List.pop_at(list, -1)
      apply_op(op, Enum.map(args, &String.to_integer/1))
    end)
  end

  def part_two(input) do
    rows = Input.read!(input) |> String.split("\n", trim: true)
    {ops, rows} = List.pop_at(rows, -1)
    rows = Enum.map(rows, &String.graphemes/1)
    ops = String.split(ops, " ", trim: true)

    rows
    |> Enum.zip_with(fn digits -> String.trim(Enum.join(digits)) end)
    |> Stream.map(fn
      "" -> nil
      str_num -> String.to_integer(str_num)
    end)
    |> Stream.chunk_by(&is_integer/1)
    |> Stream.filter(&(&1 != [nil]))
    |> Stream.zip(ops)
    |> Enum.sum_by(fn {numbers, op} -> apply_op(op, numbers) end)
  end

  defp apply_op("+", args), do: Enum.sum(args)
  defp apply_op("*", args), do: Enum.product(args)
end
