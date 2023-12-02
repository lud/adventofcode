defmodule AdventOfCode.Y23.Day2 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_game/1)
  end

  defp parse_game("Game " <> game) do
    {id, ": " <> rest} = Integer.parse(game)
    hands = rest |> String.split("; ") |> Enum.map(&parse_hand/1)
    {id, hands}
  end

  defp parse_hand(txt) do
    txt
    |> String.split(", ")
    |> Enum.map(&Integer.parse/1)
    |> Enum.reduce({0, 0, 0}, fn
      {n, " red"}, {r, g, b} -> {r + n, g, b}
      {n, " green"}, {r, g, b} -> {r, g + n, b}
      {n, " blue"}, {r, g, b} -> {r, g, b + n}
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.filter(fn {_id, hands} -> Enum.all?(hands, &lte(&1, {12, 13, 14})) end)
    |> Enum.reduce(0, fn {id, _}, acc -> acc + id end)
  end

  defp lte({r, g, b}, {max_r, max_g, max_b}) do
    r <= max_r and g <= max_g and b <= max_b
  end

  def part_two(problem) do
    problem
  end
end
