defmodule AdventOfCode.Solutions.Y15.Day01 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, _part) do
    input |> String.graphemes()
  end

  def part_one(problem) do
    problem
    |> Enum.reduce(0, fn
      "(", floor -> floor + 1
      ")", floor -> floor - 1
    end)
  end

  def part_two(problem) do
    problem
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn
      {")", i}, 0 -> throw(i)
      {")", _}, floor -> floor - 1
      {"(", _}, floor -> floor + 1
    end)
  catch
    i -> i
  end
end
