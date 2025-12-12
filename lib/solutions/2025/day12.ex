defmodule AdventOfCode.Solutions.Y25.Day12 do
  alias AoC.Input

  def parse(input, _part) do
    lines = input |> Input.stream!(trim: true) |> Enum.to_list()
    {shapes, regions} = Enum.split(lines, 24)

    shapes =
      shapes
      |> Enum.chunk_every(4)
      |> Enum.map(fn s ->
        s
        |> Enum.flat_map(&String.to_charlist/1)
        |> Enum.count(&(&1 == ?#))
      end)
      |> dbg(charlists: :as_lists)

    regions =
      Enum.map(regions, fn line ->
        [area, indices] = String.split(line, ": ")
        [w, h] = String.split(area, "x")
        area = String.to_integer(w) * String.to_integer(h)
        indices = indices |> String.split(" ") |> Enum.map(&String.to_integer/1)
        {area, indices}
      end)

    {shapes, regions}
  end

  def part_one({shapes, regions}) do
    Enum.count(regions, fn region -> region_fits?(region, shapes) end)
  end

  defp region_fits?(region, shapes) do
    {area, indices} = region
    total_tiles = Enum.zip_with(indices, shapes, fn n, size -> n * size end) |> Enum.sum()
    total_tiles <= area
  end
end
