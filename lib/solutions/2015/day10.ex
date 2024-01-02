defmodule AdventOfCode.Y15.Day10 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, _part) do
    input
  end

  def part_one({problem, times}) do
    problem |> reduce(times) |> String.length()
  end

  def part_one(problem) when is_binary(problem) do
    part_one({problem, 40})
  end

  defp reduce(int, 0) do
    int
  end

  defp reduce(int, n) do
    n |> IO.inspect(label: ~S/n/)
    int |> spell() |> reduce(n - 1)
  end

  defp spell(int) do
    [h | t] = String.graphemes(int)
    reduce_digits(t, h, 1, [])
  end

  defp reduce_digits([current | t], current, count, acc) do
    reduce_digits(t, current, count + 1, acc)
  end

  defp reduce_digits([other | t], current, count, acc) do
    reduce_digits(t, other, 1, [{Integer.to_string(count), current} | acc])
  end

  defp reduce_digits([], current, count, acc) do
    rebuild([{Integer.to_string(count), current} | acc])
  end

  defp rebuild(spells) do
    spells
    |> Enum.reverse()
    |> Enum.map(fn {count, current} -> [count, current] end)
    |> Enum.join()
  end

  # def part_two(problem) do
  #   problem
  # end
end
