defmodule Aoe.Y20.Day1 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> Input.stream_to_integers()
    |> Enum.to_list()
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    find_total(problem, 2, 2020, [])
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    find_total(problem, 3, 2020, [])
  end

  def find_total(_list, 0, 0, acc) do
    Enum.reduce(acc, &*/2)
  end

  def find_total([n | list], parts, rest, acc) when parts > 0 do
    find_total(list, parts - 1, rest - n, [n | acc]) ||
      find_total(list, parts, rest, acc)
  end

  def find_total(_, _, _, _) do
  end
end
