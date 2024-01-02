defmodule AdventOfCode.Y19.Day20 do
  alias AoC.Grid
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file)
  end

  def parse_input(input, _part) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line({string, y}) do
    string
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(&parse_cell(&1, y))
  end

  defp parse_cell({cell, x}, y) do
    case cell do
      " " -> []
      "\n" -> []
      "#" -> [{{x, y}, :wall}]
      "." -> [{{x, y}, :floor}]
      <<a>> when a in ?A..?Z -> [{{x, y}, {:tag, <<a>>}}]
    end
  end

  def part_one(map) do
    {outer_warps, inner_warps} = compute_portals(map)
    start_pos = Map.fetch!(outer_warps, :start)
    end_pos = Map.fetch!(outer_warps, :exit)

    Grid.bfs_path(map, start_pos, end_pos, fn {_, _} = xy, map ->
      base = xy |> Grid.cardinal4() |> Enum.filter(&(Map.get(map, &1) == :floor))

      case Map.get(outer_warps, xy) do
        nil -> []
        {:outer_warp, _, neigh} -> [neigh]
      end ++
        case Map.get(inner_warps, xy) do
          nil -> []
          {:inner_warp, _, neigh} -> [neigh]
        end ++ base
    end)
  end

  defp compute_portals(map) do
    {xl, xh, yl, yh} = Grid.bounds(map)

    # Find the inner space

    # Compute the wall bounds.
    {w_xl, w_xh, w_yl, w_yh} = {xl + 2, xh - 2, yl + 2, yh - 2}

    # In those walls, we try to find all spaces that are either a letter or an
    # empty space, and keep, the minmax

    {in_xl, in_xh, in_yl, in_yh} =
      for x <- w_xl..w_xh,
          y <- w_yl..w_yh,
          reduce: {99_999_999, -99_999_999, 99_999_999, -99_999_999} do
        {xl, xh, yl, yh} = acc ->
          case Map.get(map, {x, y}) do
            nil -> {min(x, xl), max(x, xh), min(y, yl), max(y, yh)}
            {:tag, _} -> {min(x, xl), max(x, xh), min(y, yl), max(y, yh)}
            :wall -> acc
            :floor -> acc
          end
      end

    tag_map = Map.filter(map, &tag_pair?/1)

    # find the inner vertically written tags. we remove all cordinates of the
    # two top and two bottom rows. Then we keep all Y values that have a letter.
    # Then we keep the first two and last two rows found, they contain vertical
    # tags. Fortunately each tag zone is reserved : they will not be horizontal
    # tags in rows where the vertical tags are written, and vice versa.

    inner_tag_map = tag_map

    outer_tags =
      :lists.flatten([
        filter_tags(
          tag_map,
          fn {_, y} -> y == yl end,
          fn {_, y} -> y == yl + 1 end,
          fn {x, _}, {x, _} ->
            {x, yl + 2}
          end
        ),
        filter_tags(
          tag_map,
          fn {_, y} -> y == yh - 1 end,
          fn {_, y} -> y == yh end,
          fn {x, _}, {x, _} ->
            {x, yh - 2}
          end
        ),
        filter_tags(
          tag_map,
          fn {x, _} -> x == xl end,
          fn {x, _} -> x == xl + 1 end,
          fn {_, y}, {_, y} ->
            {xl + 2, y}
          end
        ),
        filter_tags(
          tag_map,
          fn {x, _} -> x == xh - 1 end,
          fn {x, _} -> x == xh end,
          fn {_, y}, {_, y} ->
            {xh - 2, y}
          end
        )
      ])
      |> Map.new(fn {xy, label} -> {label, xy} end)

    inner_tags =
      :lists.flatten([
        filter_tags(
          inner_tag_map,
          fn {x, y} -> x > in_xl + 1 and x < in_xh - 1 and y == in_yl end,
          fn {x, y} -> x > in_xl + 1 and x < in_xh - 1 and y == in_yl + 1 end,
          fn {x, _}, {x, _} ->
            {x, in_yl - 1}
          end
        ),
        filter_tags(
          inner_tag_map,
          fn {x, y} -> x > in_xl + 1 and x < in_xh - 1 and y == in_yh - 1 end,
          fn {x, y} -> x > in_xl + 1 and x < in_xh - 1 and y == in_yh end,
          fn {x, _}, {x, _} ->
            {x, in_yh + 1}
          end
        ),
        # special case to support the test, we do not filter the last y rows of
        # the inner space here
        filter_tags(
          inner_tag_map,
          fn {x, _} -> x == in_xl end,
          fn {x, _} -> x == in_xl + 1 end,
          fn {_, y}, {_, y} ->
            {in_xl - 1, y}
          end
        ),
        filter_tags(
          inner_tag_map,
          fn {x, y} -> y > in_yl + 1 and y < in_yh - 1 and x == in_xh - 1 end,
          fn {x, y} -> y > in_yl + 1 and y < in_yh - 1 and x == in_xh end,
          fn {_, y}, {_, y} ->
            {in_xh + 1, y}
          end
        )
      ])
      |> Map.new(fn {xy, label} -> {label, xy} end)

    outer_warps =
      Map.new(outer_tags, fn
        {"AA", xy} -> {:start, xy}
        {"ZZ", xy} -> {:exit, xy}
        {label, xy} -> {xy, {:outer_warp, label, Map.fetch!(inner_tags, label)}}
      end)

    inner_warps =
      Map.new(inner_tags, fn
        {label, xy} ->
          {xy, {:inner_warp, label, Map.fetch!(outer_tags, label)}}
      end)

    {outer_warps, inner_warps}
  end

  defp tag_pair?({_, {:tag, _}}), do: true
  defp tag_pair?(_), do: false

  defp filter_tags(map, filter_first_letters, filter_second_letters, gen_xy) do
    first_letters = Enum.filter(map, fn {xy, _} -> filter_first_letters.(xy) end) |> Enum.sort()
    second_letters = Enum.filter(map, fn {xy, _} -> filter_second_letters.(xy) end) |> Enum.sort()

    Enum.zip_with(first_letters, second_letters, fn {xya, {:tag, a}}, {xyb, {:tag, b}} ->
      {gen_xy.(xya, xyb), a <> b}
    end)
  end

  def part_two(map) do
    {outer_warps, inner_warps} = compute_portals(map)
    {sx, sy} = Map.fetch!(outer_warps, :start)
    {ex, ey} = Map.fetch!(outer_warps, :exit)

    Grid.bfs_path(map, {sx, sy, 0}, {ex, ey, 0}, fn {x, y, z}, map ->
      base =
        {x, y}
        |> Grid.cardinal4()
        |> Enum.filter(&(Map.get(map, &1) == :floor))
        |> Enum.map(fn {nx, ny} -> {nx, ny, z} end)

      if z > 0 do
        case Map.get(outer_warps, {x, y}) do
          nil -> []
          {:outer_warp, _, {nx, ny}} -> [{nx, ny, z - 1}]
        end
      else
        []
      end ++
        case Map.get(inner_warps, {x, y}) do
          nil ->
            []

          {:inner_warp, _, {nx, ny}} ->
            [{nx, ny, z + 1}]
        end ++ base
    end)
  end
end
