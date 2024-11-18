defmodule AdventOfCode.Solutions.Y15.Day4 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, _part) do
    input
  end

  @range_width 256 * 256

  def part_one(seed) do
    solve(seed, matcher(:part_one))
  end

  def part_two(seed) do
    solve(seed, matcher(:part_two))
  end

  def solve(seed, matcher) do
    # note that 1..@range_width is not what the stream iterates on, it is the
    # initial state for the iteration. That top stream streams ranges, not
    # integers.
    1..@range_width
    |> Stream.iterate(fn _..max -> (max + 1)..(max + @range_width) end)
    |> Task.async_stream(&find_match(seed, &1, matcher))
    |> Enum.find_value(fn
      {:ok, nil} -> nil
      {:ok, n} -> n
    end)
  end

  defp find_match(seed, range, matcher) do
    Enum.find(range, fn i ->
      hash = :crypto.hash(:md5, "#{seed}#{i}")
      matcher.(hash)
    end)
  end

  defp matcher(:part_one) do
    fn
      <<0, 0, l, _::binary>> when l < 16 -> true
      _ -> false
    end
  end

  defp matcher(:part_two) do
    fn
      <<0, 0, 0, _::binary>> -> true
      _ -> false
    end
  end
end
