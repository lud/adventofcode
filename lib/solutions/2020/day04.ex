defmodule AdventOfCode.Solutions.Y20.Day04 do
  alias AoC.Input

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

  def parse_input(input, _part) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  defp parse_passport(raw) do
    raw
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(fn kv ->
      [k, v] = String.split(kv, ":")

      {k, v} =
        case {k, v} do
          {"pid", v} -> {"pid", String.to_charlist(v)}
          {"hcl", v} -> {"hcl", String.to_charlist(v)}
          kv -> kv
        end

      {String.to_atom(k), v}
    end)
    |> Map.new()
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    problem
    |> Enum.filter(&validate_passport_one/1)
    |> length()
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    problem
    |> Enum.filter(fn a -> validate_passport_one(a) && validate_passport_two(a) end)
    |> length()
  end

  defp validate_passport_one(%{byr: _, iyr: _, eyr: _, hgt: _, hcl: _, ecl: _, pid: _}) do
    true
  end

  defp validate_passport_one(_) do
    false
  end

  defp validate_passport_two(pass) do
    Enum.reduce(pass, true, fn {k, v}, acc -> acc and check_val(k, v) end)
  end

  defguard is_hex(char) when char in ?0..?f
  defguard is_digit(char) when char in ?0..?9

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  defp check_val(:byr, year) do
    case Integer.parse(year) do
      {year, ""} when year in 1920..2002 -> true
      _ -> false
    end
  end

  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  defp check_val(:iyr, year) do
    case Integer.parse(year) do
      {year, ""} when year in 2010..2020 -> true
      _ -> false
    end
  end

  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  defp check_val(:eyr, year) do
    case Integer.parse(year) do
      {year, ""} when year in 2020..2030 -> true
      _ -> false
    end
  end

  # hgt (Height) - a number followed by either cm or in:
  #     If cm, the number must be at least 150 and at most 193.
  #     If in, the number must be at least 59 and at most 76.
  defp check_val(:hgt, height) do
    case Integer.parse(height) do
      {height, "cm"} when height in 150..193 -> true
      {height, "in"} when height in 59..76 -> true
      _ -> false
    end
  end

  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  defp check_val(:hcl, [?# | digits]) when length(digits) == 6, do: Enum.all?(digits, &is_hex/1)
  defp check_val(:hcl, _), do: false

  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  defp check_val(:ecl, color) when color in ~w(amb blu brn gry grn hzl oth), do: true
  defp check_val(:ecl, _), do: false

  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  defp check_val(:pid, digits) when length(digits) == 9, do: Enum.all?(digits, &is_digit/1)
  defp check_val(:pid, _), do: false

  # cid (Country ID) - ignored, missing or not.
  defp check_val(:cid, _), do: true
end
