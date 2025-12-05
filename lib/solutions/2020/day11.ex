defmodule AdventOfCode.Solutions.Y20.Day11 do
  alias AoC.Input
  import Enum, only: [with_index: 1]

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    file
    |> Input.stream_file_lines(trim: true)
    |> Enum.to_list()
  end

  def parse_input(input, _part) do
    height = length(input)
    width = String.length(hd(input))

    map =
      for {row, y} <- with_index(input),
          {col, x} <- with_index(String.to_charlist(row)),
          into: %{},
          do: {{x, y}, col}

    {width, height, map}
  end

  def part_one({_width, _height, map}) do
    map
    |> reduce_map_p1()
    |> Enum.filter(fn {_, val} -> val == ?# end)
    |> length()
  end

  defp reduce_map_p1(map) do
    changes =
      Enum.reduce(map, [], fn {coords, val}, changes ->
        neighb_count =
          Enum.reduce(direct_neighbours(map, coords), 0, fn
            {{_, _}, ?#}, acc -> acc + 1
            _, acc -> acc
          end)

        case {val, neighb_count} do
          {?L, 0} -> [{coords, ?#} | changes]
          {?#, n} when n >= 4 -> [{coords, ?L} | changes]
          _ -> changes
        end
      end)

    case changes do
      [] -> map
      _ -> reduce_map_p1(Map.merge(map, Map.new(changes)))
    end
  end

  defp direct_neighbours(map, {x, y}) do
    Map.take(map, [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ])
  end

  def part_two({width, height, map}) do
    max_x = width - 1
    max_y = height - 1

    map
    |> reduce_map_p2(max_x, max_y)
    |> Enum.filter(fn {_, val} -> val == ?# end)
    |> length()
  end

  defp reduce_map_p2(map, max_x, max_y) do
    changes =
      Enum.reduce(map, [], fn {coords, val}, changes ->
        neighb_count = trace_rays(map, coords, max_x, max_y)

        case {val, neighb_count} do
          {?L, 0} -> [{coords, ?#} | changes]
          {?#, n} when n >= 5 -> [{coords, ?L} | changes]
          _ -> changes
        end
      end)

    case changes do
      [] -> map
      _ -> reduce_map_p2(Map.merge(map, Map.new(changes)), max_x, max_y)
    end
  end

  defp trace_rays(map, {x, y}, max_x, max_y) do
    trace_ray(map, {x + 1, y}, {+1, 0}, max_x, max_y) +
      trace_ray(map, {x - 1, y}, {-1, 0}, max_x, max_y) +
      trace_ray(map, {x, y + 1}, {0, +1}, max_x, max_y) +
      trace_ray(map, {x, y - 1}, {0, -1}, max_x, max_y) +
      trace_ray(map, {x - 1, y - 1}, {-1, -1}, max_x, max_y) +
      trace_ray(map, {x - 1, y + 1}, {-1, +1}, max_x, max_y) +
      trace_ray(map, {x + 1, y - 1}, {+1, -1}, max_x, max_y) +
      trace_ray(map, {x + 1, y + 1}, {+1, +1}, max_x, max_y)
  end

  def trace_ray(map, {x, y}, {add_x, add_y} = add, max_x, max_y)
      when x >= 0 and x <= max_x and
             y >= 0 and y <= max_y do
    case Map.get(map, {x, y}) do
      ?# -> 1
      ?L -> 0
      _ -> trace_ray(map, {x + add_x, y + add_y}, add, max_x, max_y)
    end
  end

  def trace_ray(_, _, _, _, _) do
    0
  end
end
