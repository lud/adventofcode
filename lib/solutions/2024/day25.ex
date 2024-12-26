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

  _ =
    defp parse_lock(lines) do
      coords = to_coords(lines)

      for x <- 0..4 do
        coords
        |> Enum.max_by(fn
          {^x, y} -> y
          _ -> -1
        end)
        |> elem(1)
      end
    end

  defp parse_key(lines) do
    coords = to_coords(lines)

    for x <- 0..4 do
      6 -
        (coords
         |> Enum.min_by(fn
           {^x, y} -> y
           _ -> 9999
         end)
         |> elem(1))
    end
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
  end

  def part_one(%{locks: locks, keys: keys}) do
    for lock <- locks, key <- keys, reduce: 0 do
      acc ->
        if opens?(lock, key) do
          acc + 1
        else
          acc
        end
    end
  end

  defp opens?([p | lock], [k | key]) when p + k < 6, do: opens?(lock, key)
  defp opens?([p | _], [k | _]) when p + k >= 6, do: false
  defp opens?([], []), do: true

  # def part_two(problem) do
  #   problem
  # end
end
