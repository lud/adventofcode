defmodule AdventOfCode.Y20.Day13 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, part) do
    [base, buses] =
      input
      |> String.trim()
      |> String.split("\n")

    {String.to_integer(base), parse_busints(buses, part)}
  end

  defp parse_busints(buses, :part_one) do
    buses
    |> String.split(",")
    |> Enum.filter(&(&1 != "x"))
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_busints(buses, :part_two) do
    buses
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.filter(fn {id, _} -> id != "x" end)
    |> Enum.map(fn {id, i} -> {String.to_integer(id), i} end)
  end

  def part_one({base, buses}) do
    {id, time} =
      buses
      |> Enum.map(&{&1, &1 - rem(base, &1)})
      |> Enum.min_by(fn {_, rest} -> rest end)

    id * time
  end

  def part_two({_, buses}) do
    [{id, 0} | buses] = buses
    reduce_buses(id, 0, buses)
  end

  defp reduce_buses(base, offset, [{id, i} | buses]) do
    mod = expand_mod(id, id, i)

    new_offset =
      integers()
      |> Stream.map(&(&1 * base + offset))
      |> Stream.filter(&(rem(&1, id) == mod))
      |> Enum.at(0)

    reduce_buses(base * id, new_offset, buses)
  end

  defp reduce_buses(_, new_offset, []) do
    new_offset
  end

  defp expand_mod(id, _, i) when id > i do
    id - i
  end

  defp expand_mod(id, add, i) do
    expand_mod(id + add, add, i)
  end

  def integers() do
    Stream.iterate(1, &(&1 + 1))
  end
end
