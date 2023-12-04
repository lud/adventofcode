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
      winnings = list_of_ints(winnings)
      playings = list_of_ints(playings)
      {card_id, winnings, playings}
    end)
  end

  defp list_of_ints(str) do
    str |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.map(fn {_, winnings, playings} ->
      wins = MapSet.new(winnings)
      plays = MapSet.new(playings)
      pow = MapSet.size(MapSet.intersection(wins, plays))
      trunc(:math.pow(2, pow - 1))
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map_reduce(%{}, fn {card_id, winnings, playings}, acc ->
      n_cards = 1 + Map.get(acc, card_id, 0)
      wins = MapSet.new(winnings)
      plays = MapSet.new(playings)

      acc =
        case MapSet.size(MapSet.intersection(wins, plays)) do
          0 ->
            acc

          n_wins ->
            adds = (card_id + 1)..(card_id + n_wins)

            Enum.reduce(adds, acc, fn next_card_id, acc ->
              Map.update(acc, next_card_id, n_cards, &(&1 + n_cards))
            end)
        end

      {n_cards, acc}
    end)
    |> elem(0)
    |> Enum.sum()
  end
end
