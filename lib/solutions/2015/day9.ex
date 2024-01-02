defmodule AdventOfCode.Y15.Day9 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [from, "to", to, "=", distance] = String.split(line, " ")
    {from, to, String.to_integer(distance)}
  end

  def part_one(problem) do
    # writing distances as tuples in alphabetical order as they are reciprocal
    # and only defined once in the input
    distances = Enum.reduce(problem, %{}, fn {from, to, distance}, acc -> put_distance(acc, from, to, distance) end)
    cities = distances |> Map.keys() |> Enum.flat_map(fn {from, to} -> [from, to] end) |> Enum.uniq()

    cities
    |> AoC.Permutations.of()
    |> Stream.map(fn path -> compute_total_distance(path, distances) end)
    |> Enum.min()
  end

  defp put_distance(map, from, to, distance) when from <= to do
    Map.put(map, {from, to}, distance)
  end

  defp put_distance(map, from, to, distance) do
    put_distance(map, to, from, distance)
  end

  defp get_distance(map, from, to) when from <= to do
    Map.fetch!(map, {from, to})
  end

  defp get_distance(map, from, to) do
    get_distance(map, to, from)
  end

  defp compute_total_distance(path, distances) do
    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.reduce(0, fn [from, to], acc -> acc + get_distance(distances, from, to) end)
  end
end
