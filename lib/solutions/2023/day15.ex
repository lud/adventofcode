defmodule AdventOfCode.Y23.Day15 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, :part_one) do
    input |> String.split(",") |> Enum.map(&String.to_charlist/1)
  end

  def part_one(problem) do
    problem |> Enum.map(&hash_list/1) |> Enum.sum()
  end

  defp hash_list(chars) do
    Enum.reduce(chars, 0, &hash_char/2)
  end

  defp hash_char(char, init) do
    ((init + char) * 17) |> rem(256)
  end

  # def part_two(problem) do
  #   problem
  # end
end
