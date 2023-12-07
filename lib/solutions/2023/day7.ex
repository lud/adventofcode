defmodule AdventOfCode.Y23.Day7 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, part) do
    Enum.map(input, &parse_line(&1, part))
  end

  defp parse_line(<<a, b, c, d, e, 32, bid::binary>>, part) do
    cards = [parse_card(a, part), parse_card(b, part), parse_card(c, part), parse_card(d, part), parse_card(e, part)]
    bid = String.to_integer(bid)
    {cards, bid}
  end

  @joker 1000
  defp parse_card(?2, _), do: 1002
  defp parse_card(?3, _), do: 1003
  defp parse_card(?4, _), do: 1004
  defp parse_card(?5, _), do: 1005
  defp parse_card(?6, _), do: 1006
  defp parse_card(?7, _), do: 1007
  defp parse_card(?8, _), do: 1008
  defp parse_card(?9, _), do: 1009
  defp parse_card(?T, _), do: 1010
  defp parse_card(?J, :part_one), do: 1011
  defp parse_card(?J, :part_two), do: @joker
  defp parse_card(?Q, _), do: 1012
  defp parse_card(?K, _), do: 1013
  defp parse_card(?A, _), do: 1014

  def part_one(problem) do
    problem
    |> Enum.map(fn {cards, bid} -> {htype(cards, :part_one), cards, bid} end)
    |> Enum.sort_by(fn {htype, cards, _} -> {htype, cards} end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  def part_two(problem) do
    problem
    |> Enum.map(fn {cards, bid} -> {htype(cards, :part_two), cards, bid} end)
    |> Enum.sort_by(fn {htype, cards, _} -> {htype, cards} end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp htype(cards, part) do
    cards
    |> Enum.sort()
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.sort_by(&length/1, :desc)
    |> classed_htype(part)
  end

  defp classed_htype(cards, :part_one) do
    case cards do
      [[_, _, _, _, _]] -> {9999, :cheater}
      [[a, _, _, _], [b]] -> {8888, :four_of}
      [[a, _, _], [b, _]] -> {7777, :full_house}
      [[a, _, _], [b], [c]] -> {6666, :three_of}
      [[a, _], [b, _], [c]] -> {5555, :two_pairs}
      [[a, _], [b], [c], [d]] -> {4444, :one_pair}
      [[a], [b], [c], [d], [e]] -> {3333, :nothing}
    end
  end

  defp classed_htype(cards, :part_two) do
    cards |> dbg()

    case cards do
      [[_, _, _, _, _]] -> {9999, :cheater}
      #
      [[@joker, _, _, _], [b]] -> {9999, :cheater}
      [[a, _, _, _], [@joker]] -> {9999, :cheater}
      [[a, _, _, _], [b]] -> {8888, :four_of}
      #
      [[@joker, _, _], [b, _]] -> {9999, :cheater}
      [[a, _, _], [@joker, _]] -> {9999, :cheater}
      [[a, _, _], [b, _]] -> {7777, :full_house}
      #
      [[@joker, _, _], [b], [c]] -> {8888, :four_of}
      [[a, _, _], [@joker], [c]] -> {8888, :four_of}
      [[a, _, _], [b], [@joker]] -> {8888, :four_of}
      [[a, _, _], [b], [c]] -> {6666, :three_of}
      #
      [[@joker, _], [b, _], [c]] -> {8888, :four_of}
      [[a, _], [@joker, _], [c]] -> {8888, :four_of}
      [[a, _], [b, _], [@joker]] -> {7777, :full_house}
      [[a, _], [b, _], [c]] -> {5555, :two_pairs}
      #
      [[@joker, _], [b], [c], [d]] -> {6666, :three_of}
      [[a, _], [@joker], [c], [d]] -> {6666, :three_of}
      [[a, _], [b], [@joker], [d]] -> {6666, :three_of}
      [[a, _], [b], [c], [@joker]] -> {6666, :three_of}
      [[a, _], [b], [c], [d]] -> {4444, :one_pair}
      #
      [[@joker], [b], [c], [d], [e]] -> {4444, :one_pair}
      [[a], [@joker], [c], [d], [e]] -> {4444, :one_pair}
      [[a], [b], [@joker], [d], [e]] -> {4444, :one_pair}
      [[a], [b], [c], [@joker], [e]] -> {4444, :one_pair}
      [[a], [b], [c], [d], [@joker]] -> {4444, :one_pair}
      [[a], [b], [c], [d], [e]] -> {3333, :nothing}
    end
  end
end
