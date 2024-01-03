defmodule AdventOfCode.Y15.Day16 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line("Sue " <> line) do
    [n, props] = String.split(line, ": ", parts: 2)
    n = String.to_integer(n)
    props |> String.split(", ") |> Map.new(&parse_prop/1) |> Map.put(:n, n)
  end

  defp parse_prop(kv) do
    [k, v] = String.split(kv, ": ")
    {String.to_existing_atom(k), String.to_integer(v)}
  end

  @profile %{
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
  }

  def part_one(sues) do
    last = Enum.find(sues, &match_filter(&1, @profile))
    last.n
  end

  defp match_filter(sue, profile) do
    Enum.all?(sue, fn
      {:n, _} -> true
      {k, v} -> v == Map.fetch!(profile, k)
    end)
  end

  def part_two(sues) do
    last = Enum.find(sues, &match_ranges(&1, @profile))
    last.n
  end

  defp match_ranges(sue, profile) do
    Enum.all?(sue, fn
      {:n, _} -> true
      {:cats, cats} -> cats > Map.fetch!(profile, :cats)
      {:trees, trees} -> trees > Map.fetch!(profile, :trees)
      {:pomeranians, pomeranians} -> pomeranians < Map.fetch!(profile, :pomeranians)
      {:goldfish, goldfish} -> goldfish < Map.fetch!(profile, :goldfish)
      {k, v} -> v == Map.fetch!(profile, k)
    end)
  end
end
