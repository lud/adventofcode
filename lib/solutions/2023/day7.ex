defmodule AdventOfCode.Solutions.Y23.Day7 do
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

  @joker 0
  defp parse_card(?2, _), do: 2
  defp parse_card(?3, _), do: 3
  defp parse_card(?4, _), do: 4
  defp parse_card(?5, _), do: 5
  defp parse_card(?6, _), do: 6
  defp parse_card(?7, _), do: 7
  defp parse_card(?8, _), do: 8
  defp parse_card(?9, _), do: 9
  defp parse_card(?T, _), do: 10
  defp parse_card(?J, :part_one), do: 11
  defp parse_card(?J, :part_two), do: @joker
  defp parse_card(?Q, _), do: 12
  defp parse_card(?K, _), do: 13
  defp parse_card(?A, _), do: 14

  def part_one(problem), do: solve(problem, :part_one)
  def part_two(problem), do: solve(problem, :part_two)

  defp solve(problem, part) do
    problem
    |> Enum.map(fn {cards, bid} -> {htype(cards, part), cards, bid} end)
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

  @five_of 9999
  @four_of 8888
  @full_house 7777
  @three_of 6666
  @two_pairs 5555
  @one_pair 4444
  @nothing 3333

  defp classed_htype(cards, :part_one) do
    case cards do
      [[_, _, _, _, _]] -> @five_of
      [[_, _, _, _], [_]] -> @four_of
      [[_, _, _], [_, _]] -> @full_house
      [[_, _, _], [_], [_]] -> @three_of
      [[_, _], [_, _], [_]] -> @two_pairs
      [[_, _], [_], [_], [_]] -> @one_pair
      _ -> @nothing
    end
  end

  defp classed_htype(cards, :part_two) do
    case cards do
      [[_, _, _, _, _]] -> @five_of
      #
      [[@joker, _, _, _], [_]] -> @five_of
      [[_, _, _, _], [@joker]] -> @five_of
      [[_, _, _, _], [_]] -> @four_of
      #
      [[@joker, _, _], [_, _]] -> @five_of
      [[_, _, _], [@joker, _]] -> @five_of
      [[_, _, _], [_, _]] -> @full_house
      #
      [[@joker, _, _], [_], [_]] -> @four_of
      [[_, _, _], [@joker], [_]] -> @four_of
      [[_, _, _], [_], [@joker]] -> @four_of
      [[_, _, _], [_], [_]] -> @three_of
      #
      [[@joker, _], [_, _], [_]] -> @four_of
      [[_, _], [@joker, _], [_]] -> @four_of
      [[_, _], [_, _], [@joker]] -> @full_house
      [[_, _], [_, _], [_]] -> @two_pairs
      #
      [[@joker, _], [_], [_], [_]] -> @three_of
      [[_, _], [@joker], [_], [_]] -> @three_of
      [[_, _], [_], [@joker], [_]] -> @three_of
      [[_, _], [_], [_], [@joker]] -> @three_of
      [[_, _], [_], [_], [_]] -> @one_pair
      #
      [[@joker], [_], [_], [_], [_]] -> @one_pair
      [[_], [@joker], [_], [_], [_]] -> @one_pair
      [[_], [_], [@joker], [_], [_]] -> @one_pair
      [[_], [_], [_], [@joker], [_]] -> @one_pair
      [[_], [_], [_], [_], [@joker]] -> @one_pair
      [[_], [_], [_], [_], [_]] -> @nothing
    end
  end
end
