defmodule AdventOfCode.Solutions.Y24.Day04 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Grid.parse_stream(fn <<c>> -> {:ok, c} end)
  end

  def part_one(grid) do
    grid
    |> Map.keys()
    |> Enum.map(&count_xmas(&1, grid))
    |> Enum.sum()
  end

  defp count_xmas(pos, grid) do
    for dir <- Grid.directions(8), step <- 0..3 do
      Grid.translate(pos, dir, step)
    end
    |> Enum.chunk_every(4)
    |> Enum.map(&to_word(&1, grid))
    |> Enum.filter(&(&1 == ~c"XMAS"))
    |> length()
  end

  defp to_word(coords, grid) do
    coords
    |> Enum.map(&Map.get(grid, &1))
    |> Enum.reject(&is_nil/1)
  end

  def part_two(grid) do
    grid
    |> Enum.filter(fn {_, c} -> c == ?A end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.count(&is_cross(&1, grid))
  end

  defp is_cross(pos, grid) do
    nw = Map.get(grid, Grid.translate(pos, :nw))
    se = Map.get(grid, Grid.translate(pos, :se))
    sw = Map.get(grid, Grid.translate(pos, :sw))
    ne = Map.get(grid, Grid.translate(pos, :ne))

    ((nw == ?M and se == ?S) or (nw == ?S and se == ?M)) and
      ((ne == ?M and sw == ?S) or (ne == ?S and sw == ?M))
  end
end
