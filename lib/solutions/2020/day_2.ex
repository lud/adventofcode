defmodule Aoe.Y20.Day2 do
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
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    problem
    |> Enum.filter(&validate_one/1)
    |> length
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    problem
    |> Enum.filter(&validate_two/1)
    |> length
  end

  @re ~r/^([0-9]+)-([0-9]+) ([a-z]): (.*)$/

  defp parse_line(line) do
    [lo, hi, <<char::8>>, password] = Regex.run(@re, line, capture: :all_but_first)
    {String.to_integer(lo), String.to_integer(hi), char, password}
  end

  defp validate_one({lo, hi, char, password}) do
    validate_one(password, char, _count = 0, lo, hi)
  end

  defp validate_one(<<char, password::binary>>, char, count, lo, hi) when count == hi,
    do: false

  defp validate_one(<<char, password::binary>>, char, count, lo, hi),
    do: validate_one(password, char, count + 1, lo, hi)

  defp validate_one(<<_, password::binary>>, char, count, lo, hi),
    do: validate_one(password, char, count, lo, hi)

  defp validate_one(<<>>, char, count, lo, hi) when count < lo,
    do: false

  defp validate_one(<<>>, char, count, lo, hi),
    do: true

  defp validate_two({i, j, char, pass}) do
    case {
      :binary.at(pass, i - 1) == char,
      :binary.at(pass, j - 1) == char
    } do
      {a, b} when a != b -> true
      _ -> false
    end
  end
end
