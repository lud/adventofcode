defmodule AdventOfCode.Solutions.Y15.Day05 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
  end

  def part_one(problem) do
    problem
    |> Enum.count(&nice?/1)
  end

  def part_two(problem) do
    problem
    |> Enum.count(&valid?/1)
  end

  @vowels ~w(a e i o u)
  @forbidden ~w(ab cd pq xy)
  def nice?(str) do
    chars = String.graphemes(str)

    with true <- least_vowels(chars),
         true <- double?(chars) do
      not forbidden?(str)
    end
  end

  defp least_vowels(str) do
    count_vowels(str, 0) >= 3
  end

  defp count_vowels([c | t], n) when c in @vowels, do: count_vowels(t, n + 1)
  defp count_vowels([_ | t], n), do: count_vowels(t, n)
  defp count_vowels([], n), do: n

  defp double?([c, c | _]), do: true
  defp double?([_, x | t]), do: double?([x | t])
  defp double?([_]), do: false

  defp forbidden?(str) do
    Enum.any?(@forbidden, &String.contains?(str, &1))
  end

  defp valid?(str) do
    chars = String.graphemes(str)

    with true <- pair?(chars), do: repeat?(chars)
  end

  defp pair?([a, b | t]) do
    if contains_pair?(t, a, b) do
      true
    else
      pair?([b | t])
    end
  end

  defp pair?([_]) do
    false
  end

  defp contains_pair?([a, b | _], a, b), do: true
  defp contains_pair?([_, c | t], a, b), do: contains_pair?([c | t], a, b)
  defp contains_pair?([_], _, _), do: false
  defp contains_pair?([], _, _), do: false

  defp repeat?([c, a, c | _]) when a != c, do: true
  defp repeat?([_, a, c | t]), do: repeat?([a, c | t])
  defp repeat?([_, _]), do: false
end
