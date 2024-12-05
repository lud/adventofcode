defmodule AdventOfCode.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    lines = Input.read!(input) |> String.trim()
    [pairs, updates] = String.split(lines, "\n\n")

    {parse_pairs(pairs), parse_updates(updates)}
  end

  defp parse_pairs(raw) do
    raw
    |> String.split("\n")
    |> Enum.map(fn line ->
      [a, b] = String.split(line, "|")
      {String.to_integer(a), String.to_integer(b)}
    end)
  end

  defp parse_updates(raw) do
    raw
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split(",") |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_one({pairs, updates}) do
    updates
    |> Enum.filter(&good_update?(&1, pairs))
    |> Enum.map(&at_middle/1)
    |> Enum.sum()
  end

  defp good_update?([_last], _) do
    true
  end

  defp good_update?([left | tail], pairs) do
    Enum.all?(tail, fn right -> {left, right} in pairs end) and good_update?(tail, pairs)
  end

  defp at_middle(list) do
    Enum.at(list, div(length(list), 2))
  end

  def part_two({pairs, updates}) do
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

  defp insert([], n, _) do
    [n]
  end
end
