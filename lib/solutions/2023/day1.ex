defmodule Aoe.Y23.Day1 do
  alias Aoe.Input, warn: false

  def read_file!(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input!(input, _part) do
    input
  end

  def part_one(problem) do
    problem
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&solve_line_p1/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp solve_line_p1(chars) do
    digits = Enum.filter(chars, &(&1 in ?0..?9))
    {first, last} = first_last(digits)
    List.to_integer([first, last])
  end

  defp first_last(items) do
    [h | _] = items
    [g | _] = :lists.reverse(items)
    {h, g}
  end

  def part_two(problem) do
    problem
    |> Enum.map(&solve_line_p2/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp solve_line_p2(line) do
    line
    |> collect_digits([])
    |> first_last()
    |> then(fn {a, b} -> a * 10 + b end)
  end

  defp collect_digits(<<c, rest::binary>>, acc) when c in ?0..?9,
    do: collect_digits(rest, [c - ?0 | acc])

  defp collect_digits(<<"one", rest::binary>>, acc),
    do: collect_digits(<<"ne", rest::binary>>, [1 | acc])

  defp collect_digits(<<"two", rest::binary>>, acc),
    do: collect_digits(<<"wo", rest::binary>>, [2 | acc])

  defp collect_digits(<<"three", rest::binary>>, acc),
    do: collect_digits(<<"hree", rest::binary>>, [3 | acc])

  defp collect_digits(<<"four", rest::binary>>, acc),
    do: collect_digits(<<"our", rest::binary>>, [4 | acc])

  defp collect_digits(<<"five", rest::binary>>, acc),
    do: collect_digits(<<"ive", rest::binary>>, [5 | acc])

  defp collect_digits(<<"six", rest::binary>>, acc),
    do: collect_digits(<<"ix", rest::binary>>, [6 | acc])

  defp collect_digits(<<"seven", rest::binary>>, acc),
    do: collect_digits(<<"even", rest::binary>>, [7 | acc])

  defp collect_digits(<<"eight", rest::binary>>, acc),
    do: collect_digits(<<"ight", rest::binary>>, [8 | acc])

  defp collect_digits(<<"nine", rest::binary>>, acc),
    do: collect_digits(<<"ine", rest::binary>>, [9 | acc])

  defp collect_digits(<<_, rest::binary>>, acc), do: collect_digits(rest, acc)
  defp collect_digits(<<>>, acc), do: :lists.reverse(acc)
end
