defmodule AdventOfCode.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    lines = Input.read!(input) |> String.trim()
    [pairs, updates] = String.split(lines, "\n\n")

    pairs =
      pairs
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, "|")
        |> Enum.map(&String.to_integer/1)
        |> case do
          [a, b] -> {a, b}
        end
      end)

    updates =
      updates
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    {pairs, updates}
  end

  def part_one(problem) do
    {pairs, updates} = problem

    updates
    |> Enum.filter(&good_update?(&1, pairs))
    |> Enum.map(&at_middle/1)
    |> Enum.sum()
  end

  defp good_update?([left], pairs) do
    true
  end

  defp good_update?([left | tail], pairs) do
    IO.puts("---------")

    Enum.all?(tail, fn right ->
      {left, right} |> dbg()
      ({left, right} in pairs) |> dbg()
    end) and good_update?(tail, pairs)
  end

  defp at_middle(list) do
    len = length(list)
    true = rem(len, 2) == 1
    list |> dbg()
    Enum.at(list, div(length(list), 2)) |> dbg()
  end

  def part_two(problem) do
    {pairs, updates} = problem

    updates
    |> Enum.filter(&(not good_update?(&1, pairs)))
    |> Enum.map(&reorder(&1, pairs))
    |> Enum.map(&at_middle/1)
    |> Enum.sum()
  end

  defp reorder([h | t], pairs) do
    reorder(t, [h], pairs)
  end

  defp reorder([h | t], ordered, pairs) do
    reorder(t, insert(ordered, h, pairs), pairs)
  end

  defp reorder([], ordered, _), do: ordered

  defp insert([h | t], n, pairs) do
    if {h, n} in pairs,
      do: [h | insert(t, n, pairs)],
      else: [n, h | t]
  end

  defp insert([], n, pairs) do
    [n]
  end
end
