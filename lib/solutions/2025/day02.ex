defmodule AdventOfCode.Solutions.Y25.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn range ->
      [left, right] = String.split(range, "-")
      left = String.to_integer(left)
      right = String.to_integer(right)
      left..right
    end)
  end

  def part_one(problem) do
    problem
    |> Stream.flat_map(& &1)
    |> Stream.filter(&invalid_p1?/1)
    |> Enum.sum()
  end

  defp invalid_p1?(n) do
    splits?(Integer.digits(n))
  end

  defp splits?([a, a]), do: true
  defp splits?([a, b, a, b]), do: true
  defp splits?([a, b, c, a, b, c]), do: true
  defp splits?([a, b, c, d, a, b, c, d]), do: true
  defp splits?([a, b, c, d, e, a, b, c, d, e]), do: true
  defp splits?(_), do: false

  def part_two(problem) do
    problem
    |> Stream.flat_map(& &1)
    |> Stream.filter(&invalid_p2?/1)
    |> Enum.sum()
  end

  defp invalid_p2?(n) do
    repeats?(Integer.digits(n))
  end

  defp repeats?([a, a]), do: true
  defp repeats?([a, a, a]), do: true
  defp repeats?([a, b, a, b]), do: true
  defp repeats?([a, a, a, a, a]), do: true
  defp repeats?([a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, a, b, c]), do: true
  defp repeats?([a, a, a, a, a, a, a]), do: true
  defp repeats?([a, b, a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, d, a, b, c, d]), do: true
  defp repeats?([a, a, a, a, a, a, a, a, a]), do: true
  defp repeats?([a, b, c, a, b, c, a, b, c]), do: true
  defp repeats?([a, b, a, b, a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, d, e, a, b, c, d, e]), do: true
  defp repeats?(_), do: false
end
