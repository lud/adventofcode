defmodule AdventOfCode.Solutions.Y24.Day25 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_block/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp parse_block("#####\n" <> _ = lock), do: {:locks, parse_lock(lock)}
  defp parse_block(".....\n" <> _ = key), do: {:keys, parse_key(key)}

  defp parse_lock(lines) do
    coords = to_coords(lines)
    Enum.map(0..4, fn x -> Enum.max(Map.fetch!(coords, x)) end)
  end

  defp parse_key(lines) do
    coords = to_coords(lines)
    Enum.map(0..4, fn x -> 6 - Enum.min(Map.fetch!(coords, x)) end)
  end

  defp to_coords(lines) do
    lines
    |> String.split("\n")
    |> Grid.parse_lines(fn
      ?# -> {:ok, true}
      ?. -> :ignore
    end)
    |> elem(0)
    |> Map.keys()
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  def part_one(%{locks: locks, keys: keys}) do
    for lock <- locks, key <- keys, reduce: 0 do
      acc -> if opens?(lock, key), do: acc + 1, else: acc
    end
  end

  defp opens?([p | lock], [k | key]) when p + k < 6, do: opens?(lock, key)
  defp opens?([_ | _], [_ | _]), do: false
  defp opens?([], []), do: true
end
