defmodule AdventOfCode.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    String.trim(Input.read!(input))
  end

  def part_one(problem) do
    ~r/mul\(([0-9]{1,3}),([0-9]{1,3})\)/
    |> Regex.scan(problem)
    |> Enum.reduce(0, fn [_, a, b], acc ->
      String.to_integer(a) * String.to_integer(b) + acc
    end)
  end

  def part_two(problem) do
    ~r/(mul\(([0-9]{1,3}),([0-9]{1,3})\)|do\(\)|don't\(\))/
    |> Regex.scan(problem)
    |> Enum.reduce({0, true}, fn
      ["do()" | _], {acc, _enabled?} -> {acc, true}
      ["don't()" | _], {acc, _enabled?} -> {acc, false}
      [_, _, a, b], {acc, true} -> {String.to_integer(a) * String.to_integer(b) + acc, true}
      [_, _, _, _], {acc, false} -> {acc, false}
    end)
    |> elem(0)
  end
end
