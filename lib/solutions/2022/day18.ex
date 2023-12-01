defmodule Aoe.Y22.Day18 do
  alias Aoe.Input, warn: false

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [x, y, z] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
    {x, y, z}
  end

  def part_one(cube_list) do
    lookup_map = Map.new(cube_list, &{&1, true})

    surf_map =
      Enum.reduce(cube_list, %{}, fn cube, surf_map ->
        Map.put(surf_map, cube, n_uncovered(cube, lookup_map))
      end)

    surf_map |> Map.values() |> Enum.sum()
  end

  def part_two(cube_list) do
    lookup_map = Map.new(cube_list, &{&1, true})

    xl = Enum.reduce(cube_list, &min_x/2) - 1
    yl = Enum.reduce(cube_list, &min_y/2) - 1
    zl = Enum.reduce(cube_list, &min_z/2) - 1

    xh = Enum.reduce(cube_list, &max_x/2) + 1
    yh = Enum.reduce(cube_list, &max_y/2) + 1
    zh = Enum.reduce(cube_list, &max_z/2) + 1

    path_start = {xl, yl, zl}
    max_range = {xh, yh, zh}

    explored = explore([path_start], {path_start, max_range}, lookup_map, %{})

    explored |> Map.values() |> Enum.sum()
  end

  defp explore([cur | open], minmax, lookup_map, explored) do
    {lava_neighs, free_neighs} = split_neighs(cur, lookup_map, minmax)
    faces = length(lava_neighs)
    explored = Map.put(explored, cur, faces)
    free_neighs = Enum.filter(free_neighs, &(&1 not in open and not Map.has_key?(explored, &1)))
    explore(free_neighs ++ open, minmax, lookup_map, explored)
  end

  defp explore([], _, _, explored) do
    explored
  end

  defp split_neighs(cube, lookup_map, minmax) do
    neighs = cardinal_neighbours(cube)
    {lava_neighs, free_neighs} = Enum.split_with(neighs, &Map.has_key?(lookup_map, &1))
    free_neighs = clamp_neighs(free_neighs, minmax)
    {lava_neighs, free_neighs}
  end

  defp clamp_neighs(cubes, minmax) do
    Enum.filter(cubes, &in_boundary(&1, minmax))
  end

  defp in_boundary({x, y, z}, {{xl, yl, zl}, {xh, yh, zh}}) do
    x >= xl and x <= xh and
      y >= yl and y <= yh and
      z >= zl and z <= zh
  end

  defp n_uncovered(cube, lookup_map) do
    cube |> cardinal_neighbours() |> Enum.reject(&Map.has_key?(lookup_map, &1)) |> Enum.count()
  end

  defp cardinal_neighbours({x, y, z}) do
    [
      {x - 1, y, z},
      {x + 1, y, z},
      {x, y - 1, z},
      {x, y + 1, z},
      {x, y, z - 1},
      {x, y, z + 1}
    ]
  end

  defp max_x({a, _, _}, {b, _, _}), do: max(a, b)
  defp max_x({a, _, _}, b) when is_integer(b), do: max(a, b)
  defp min_x({a, _, _}, {b, _, _}), do: min(a, b)
  defp min_x({a, _, _}, b) when is_integer(b), do: min(a, b)
  defp max_y({_, a, _}, {_, b, _}), do: max(a, b)
  defp max_y({_, a, _}, b) when is_integer(b), do: max(a, b)
  defp min_y({_, a, _}, {_, b, _}), do: min(a, b)
  defp min_y({_, a, _}, b) when is_integer(b), do: min(a, b)
  defp max_z({_, _, a}, {_, _, b}), do: max(a, b)
  defp max_z({_, _, a}, b) when is_integer(b), do: max(a, b)
  defp min_z({_, _, a}, {_, _, b}), do: min(a, b)
  defp min_z({_, _, a}, b) when is_integer(b), do: min(a, b)
end
