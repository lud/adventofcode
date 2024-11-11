defmodule AdventOfCode.Y20.Day2 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    Enum.reduce(problem, 0, &if(validate_one(&1), do: &2 + 1, else: &2))
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    Enum.reduce(problem, 0, &if(validate_two(&1), do: &2 + 1, else: &2))
  end

  @re ~r/^([0-9]+)-([0-9]+) ([a-z]): (.*)$/

  defp parse_line(line) do
    [lo, hi, <<char::8>>, password] = Regex.run(@re, line, capture: :all_but_first)
    {String.to_integer(lo), String.to_integer(hi), char, String.to_charlist(password)}
  end

  defp validate_one({lo, hi, char, password}) do
    len =
      password
      |> Enum.filter(&(&1 == char))
      |> length

    len >= lo and len <= hi
  end

  defp validate_two({i, j, char, pass}) do
    case {Enum.at(pass, i - 1) == char, Enum.at(pass, j - 1) == char} do
      {a, b} when a != b -> true
      _ -> false
    end
  end
end

# defp validate_one(<<char, password::binary>>, char, count, lo, hi) when count == hi,
#   do: false

# defp validate_one(<<char, password::binary>>, char, count, lo, hi),
#   do: validate_one(password, char, count + 1, lo, hi)

# defp validate_one(<<_, password::binary>>, char, count, lo, hi),
#   do: validate_one(password, char, count, lo, hi)

# defp validate_one(<<>>, char, count, lo, hi) when count < lo,
#   do: false

# defp validate_one(<<>>, char, count, lo, hi),
#   do: true
