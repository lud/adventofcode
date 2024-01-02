defmodule AdventOfCode.Y15.Day12 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    Jason.decode!(input)
  end

  def part_one(problem) do
    count_everything(problem, 0)
  end

  defp count_everything(map, acc) when is_map(map) do
    Enum.reduce(map, acc, fn {_, v}, acc -> count_everything(v, acc) end)
  end

  defp count_everything(int, acc) when is_integer(int) do
    acc + int
  end

  defp count_everything(list, acc) when is_list(list) do
    Enum.reduce(list, acc, fn item, acc -> count_everything(item, acc) end)
  end

  defp count_everything(str, acc) when is_binary(str) do
    acc
  end

  def part_two(problem) do
    count_no_red(problem, 0)
  end

  defp count_no_red(map, acc) when is_map(map) do
    if Enum.any?(map, fn {_, v} -> v == "red" end) do
      acc
    else
      Enum.reduce(map, acc, fn {_, v}, acc -> count_no_red(v, acc) end)
    end
  end

  defp count_no_red(int, acc) when is_integer(int) do
    acc + int
  end

  defp count_no_red(list, acc) when is_list(list) do
    Enum.reduce(list, acc, fn item, acc -> count_no_red(item, acc) end)
  end

  defp count_no_red(str, acc) when is_binary(str) do
    acc
  end
end
