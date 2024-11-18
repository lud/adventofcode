defmodule AdventOfCode.Solutions.Y15.Day17 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem, liters \\ 150) do
    # We have N containers. We will generate permutations of those containers,
    # using bits to tell which container is used.
    max_int = trunc(:math.pow(2, length(problem))) - 1

    1..max_int
    |> Stream.map(&match_containers(&1, problem))
    |> Enum.count(fn {contains, _} -> contains == liters end)
  end

  def part_two(problem, liters \\ 150) do
    max_int = trunc(:math.pow(2, length(problem))) - 1

    1..max_int
    |> Stream.map(&match_containers(&1, problem))
    |> Enum.reduce({99999, 0}, fn
      {^liters, same}, {same, n_best} -> {same, n_best + 1}
      {^liters, lower}, {best, _} when lower < best -> {lower, 1}
      _, acc -> acc
    end)
    |> elem(1)
  end

  defp match_containers(int, containers) do
    match_containers(int, containers, 1, 0, 0)
  end

  defp match_containers(n, [h | t], pw, sum, count) when Bitwise.band(n, pw) == pw do
    match_containers(n, t, pw * 2, sum + h, count + 1)
  end

  defp match_containers(n, [_ | t], pw, sum, count) do
    match_containers(n, t, pw * 2, sum, count)
  end

  defp match_containers(_, [], _, sum, count) do
    {sum, count}
  end
end
