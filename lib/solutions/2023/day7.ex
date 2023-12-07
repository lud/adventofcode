defmodule AdventOfCode.Y23.Day7 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    Enum.map(input, &parse_line/1)
  end

  defp parse_line(<<a, b, c, d, e, 32, bid::binary>>) do
    cards = [parse_card(a), parse_card(b), parse_card(c), parse_card(d), parse_card(e)]
    bid = String.to_integer(bid)
    {cards, bid}
  end

  defp parse_card(?2), do: {1002, <<?2>>}
  defp parse_card(?3), do: {1003, <<?3>>}
  defp parse_card(?4), do: {1004, <<?4>>}
  defp parse_card(?5), do: {1005, <<?5>>}
  defp parse_card(?6), do: {1006, <<?6>>}
  defp parse_card(?7), do: {1007, <<?7>>}
  defp parse_card(?8), do: {1008, <<?8>>}
  defp parse_card(?9), do: {1009, <<?9>>}
  defp parse_card(?T), do: {1010, <<?T>>}
  defp parse_card(?J), do: {1011, <<?J>>}
  defp parse_card(?Q), do: {1012, <<?Q>>}
  defp parse_card(?K), do: {1013, <<?K>>}
  defp parse_card(?A), do: {1014, <<?A>>}

  def part_one(problem) do
    problem
    |> Enum.map(fn {cards, bid} -> {htype(cards), cards, bid} end)
    |> Enum.sort_by(fn {htype, cards, _} -> {htype, cards} end)
    |> Enum.with_index(1)
    |> dbg(limit: :infinity)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp htype(cards) do
    cards
    |> Enum.sort()
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.sort_by(&length/1, :desc)
    |> case do
      [[_, _, _, _, _]] ->
        {9999, :full_house}

      [[a, _, _, _], [b]] when a != b ->
        {8888, :four_of}

      [[a, _, _], [b, _]] when a != b ->
        {7777, :full_house}

      [[a, _, _], [b], [c]] when a != b and a != c and b != c ->
        {6666, :three_of}

      [[a, _], [b, _], [c]] when a != b and a != c and b != c ->
        {5555, :two_pairs}

      [[a, _], [b], [c], [d]]
      when a != b and a != c and a != d and b != c and b != d and c != d ->
        {4444, :one_pair}

      [[a], [b], [c], [d], [e]]
      when a != b and a != c and a != d and a != e and b != c and b != d and b != e and c != d and c != e and d != e ->
        {3333, :nothing}
    end
  end

  # def part_two(problem) do
  #   problem
  # end
end
