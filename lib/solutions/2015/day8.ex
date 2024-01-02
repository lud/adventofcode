defmodule AdventOfCode.Y15.Day8 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&String.to_charlist/1)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&diff_p1/1)
    |> Enum.sum()
  end

  defp diff_p1(original = chars) do
    [?" | chars] = chars
    [?" | chars] = :lists.reverse(chars)
    chars = :lists.reverse(chars)
    chars = unescape(chars)
    length(original) - length(chars)
  end

  defp unescape([?\\, ?" | chars]), do: [?" | unescape(chars)]
  defp unescape([?\\, ?\\ | chars]), do: [?\\ | unescape(chars)]
  defp unescape([?\\, ?x, a, b | chars]), do: [hexchar(a, b) | unescape(chars)]
  defp unescape([c | chars]), do: [c | unescape(chars)]
  defp unescape([]), do: []

  defp hexchar(a, b) do
    hexchar(a) * 16 + hexchar(b)
  end

  defp hexchar(?0), do: 0
  defp hexchar(?1), do: 1
  defp hexchar(?2), do: 2
  defp hexchar(?3), do: 3
  defp hexchar(?4), do: 4
  defp hexchar(?5), do: 5
  defp hexchar(?6), do: 6
  defp hexchar(?7), do: 7
  defp hexchar(?8), do: 8
  defp hexchar(?9), do: 9
  defp hexchar(?a), do: 10
  defp hexchar(?b), do: 11
  defp hexchar(?c), do: 12
  defp hexchar(?d), do: 13
  defp hexchar(?e), do: 14
  defp hexchar(?f), do: 15

  def part_two(problem) do
    problem
    |> Enum.map(&diff_p2/1)
    |> Enum.sum()
  end

  defp diff_p2(original = chars) do
    chars = [?" | escape(chars)] ++ [?"]
    length(chars) - length(original)
  end

  defp escape([?" | chars]), do: [?\\, ?" | escape(chars)]
  defp escape([?\\ | chars]), do: [?\\, ?\\ | escape(chars)]
  defp escape([c | chars]), do: [c | escape(chars)]
  defp escape([]), do: []
end
