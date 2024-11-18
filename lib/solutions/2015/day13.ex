defmodule AdventOfCode.Y15.Day13 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1) |> Map.new()
  end

  defp parse_line(line) do
    line = String.trim_trailing(line, ".")

    [name1, "would", kind, points, "happiness", "units", "by", "sitting", "next", "to", name2] =
      String.split(line, " ")

    points = String.to_integer(points)

    points =
      case kind do
        "gain" -> points
        "lose" -> -points
      end

    {{name1, name2}, points}
  end

  def part_one(problem) do
    names = Enum.map(problem, fn {{name1, _name2}, _} -> name1 end) |> Enum.uniq()
    perms = AdventOfCode.Permutations.of(names) |> Enum.to_list()

    perms
    |> Stream.map(&happiness(&1, problem))
    |> Enum.max()
  end

  def part_two(problem) do
    names = Enum.map(problem, fn {{name1, _name2}, _} -> name1 end) |> Enum.uniq()

    Enum.flat_map(names, &[{"Me", &1}, {&1, "Me"}])
    |> Map.new(&{&1, 0})
    |> Map.merge(problem)
    |> part_one()
  end

  defp happiness(seats, map) do
    [h | _] = seats
    last = List.last(seats)
    round = [last | seats] ++ [h]
    positions = Enum.chunk_every(round, 3, 1, :discard)

    Enum.reduce(positions, 0, fn [left, who, right], change ->
      change + Map.fetch!(map, {who, left}) + Map.fetch!(map, {who, right})
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
