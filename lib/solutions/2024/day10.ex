defmodule AdventOfCode.Solutions.Y24.Day10 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!()
    |> Grid.parse_lines(fn
      ?. -> :ignore
      c -> {:ok, c - ?0}
    end)
    |> elem(0)
  end

  def part_one(grid) do
    scores =
      for h <- heads(grid), s <- summits(grid), reduce: %{} do
        scores ->
          case Grid.bfs_path(grid, h, s, &uphill_neighbors/2) do
            {:error, :no_path} -> scores
            {:ok, _} -> Map.update(scores, h, 1, &(&1 + 1))
          end
      end

    scores |> Map.values() |> Enum.sum()
  end

  defp heads(grid), do: keys_for_altitude(grid, 0)
  defp summits(grid), do: keys_for_altitude(grid, 9)

  defp keys_for_altitude(grid, altitude) do
    Enum.flat_map(grid, fn
      {k, ^altitude} -> [k]
      _ -> []
    end)
  end

  defp uphill_neighbors(pos, grid) do
    uphill_neighbors(pos, grid, _altitude = Map.fetch!(grid, pos) + 1)
  end

  defp uphill_neighbors(pos, grid, altitude) do
    pos
    |> Grid.cardinal4()
    |> Enum.filter(&(Map.get(grid, &1) == altitude))
  end

  def part_two(grid) do
    scores =
      for h <- heads(grid), s <- summits(grid), reduce: %{} do
        scores ->
          case Grid.bfs_path(grid, h, s, &uphill_neighbors/2) do
            {:error, :no_path} ->
              scores

            {:ok, _} ->
              rating = rating(grid, h, s)
              Map.update(scores, h, rating, &(&1 + rating))
          end
      end

    scores |> Map.values() |> Enum.sum()
  end

  defp rating(grid, head, summit) do
    points =
      Enum.reduce(1..9, [head], fn altitude, points ->
        all_neighs(grid, points, altitude)
      end)

    Enum.count(points, &(&1 == summit))
  end

  defp all_neighs(grid, poses, altitude) do
    Enum.flat_map(poses, fn pos ->
      uphill_neighbors(pos, grid, altitude)
    end)
  end
end
