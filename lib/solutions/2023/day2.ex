defmodule AdventOfCode.Y23.Day2 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _) do
    Enum.map(input, &parse_game(&1, {0, 0, 0}))
  end

  defp parse_game("Game " <> game, base) do
    {id, ": " <> rest} = Integer.parse(game)
    hands = rest |> String.split("; ") |> Enum.map(&parse_hand(&1, base))
    {id, hands}
  end

  defp parse_hand(txt, base) do
    txt
    |> String.split(", ")
    |> Enum.map(&Integer.parse/1)
    |> Enum.reduce(base |> dbg(), fn
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
    |> Enum.map(&power/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp power({_id, hands}) do
    hands
    |> Enum.reduce(fn {r, g, b}, {min_r, min_g, min_b} ->
      {max(min_r, r), max(min_g, g), max(min_b, b)}
    end)
    |> case do
      {r, g, b} -> r * g * b
    end
    |> dbg()
  end
end
