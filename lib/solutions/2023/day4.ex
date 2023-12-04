defmodule AdventOfCode.Y23.Day4 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Enum.map(fn "Card " <> rest ->
      rest = String.trim_leading(rest)
      {card_id, ": " <> rest} = Integer.parse(rest)
      [winnings, playings] = String.split(rest, " | ")
      winnings = winnings |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      playings = playings |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      {card_id, winnings, playings}
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.map(fn {_card_id, winnings, playings} ->
      wins = MapSet.new(winnings)
      plays = MapSet.new(playings)
      pow = MapSet.size(MapSet.intersection(wins, plays))
      trunc(:math.pow(2, pow - 1))
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
  end
end
