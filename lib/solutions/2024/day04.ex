defmodule AdventOfCode.Solutions.Y24.Day04 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Grid.parse_lines(fn c -> {:ok, c} end)
    |> elem(0)
  end

  def part_one(grid) do
    grid
    |> Enum.filter(fn {_, c} -> c == ?X end)
    |> Enum.map(&elem(&1, 0))
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
    Enum.map(coords, &Map.get(grid, &1))
  end

  def part_two(grid) do
    grid
    |> Enum.filter(fn {_, c} -> c == ?A end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.count(&cross?(&1, grid))
  end

  defp cross?(pos, grid) do
    nw = Map.get(grid, Grid.translate(pos, :nw))
    se = Map.get(grid, Grid.translate(pos, :se))
    sw = Map.get(grid, Grid.translate(pos, :sw))
    ne = Map.get(grid, Grid.translate(pos, :ne))

    ((nw == ?M and se == ?S) or (nw == ?S and se == ?M)) and
      ((ne == ?M and sw == ?S) or (ne == ?S and sw == ?M))
  end
end
