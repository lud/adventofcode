defmodule AdventOfCode.Solutions.Y24.Day10 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!() |> Grid.parse_lines(fn c -> {:ok, c - ?0} end) |> elem(0)
  end

  def part_one(grid) do
    heads =
      Enum.flat_map(grid, fn
        {k, 0} -> [k]
        _ -> []
      end)

    summits =
      Enum.flat_map(grid, fn
        {k, 9} -> [k]
        _ -> []
      end)

    scores =
      for h <- heads, s <- summits, reduce: %{} do
        scores ->
          case Grid.bfs_path(grid, h, s, &uphill_neighbors/2) do
            {:error, :no_path} -> scores
            {:ok, _} -> Map.update(scores, h, 1, &(&1 + 1))
          end
      end

    scores |> Map.values() |> Enum.sum()
  end

  defp uphill_neighbors(pos, grid) do
    altitude = Map.fetch!(grid, pos)
    higher = altitude + 1

    pos
    |> Grid.cardinal4()
    |> Enum.filter(&(Map.get(grid, &1) == higher))
  end

  # def part_two(problem) do
  #   problem
  # end
end
