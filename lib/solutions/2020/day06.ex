defmodule AdventOfCode.Solutions.Y20.Day06 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, :part_one) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", ""))
  end

  def parse_input(input, :part_two) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)
    end)
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    problem
    |> Enum.map(fn group -> group |> String.graphemes() |> Enum.uniq() |> length end)
    |> Enum.sum()
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    problem
    |> Enum.map(fn group -> group |> Enum.reduce(&(&1 -- &1 -- &2)) |> length end)
    |> Enum.sum()
  end
end
