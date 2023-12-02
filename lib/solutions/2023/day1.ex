defmodule AdventOfCode.Y23.Day1 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
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
    {hd(items), List.last(items)}
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

  ~w(one two three four five six seven eight nine)
  |> Enum.with_index(1)
  |> Enum.each(fn {<<c, keep::binary>>, digit} ->
    defp collect_digits(<<unquote(c), unquote(keep)::binary, rest::binary>>, acc) do
      collect_digits(<<unquote(keep)::binary, rest::binary>>, [unquote(digit) | acc])
    end
  end)

  defp collect_digits(<<_, rest::binary>>, acc), do: collect_digits(rest, acc)
  defp collect_digits(<<>>, acc), do: :lists.reverse(acc)
end
