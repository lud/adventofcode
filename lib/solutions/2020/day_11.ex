defmodule Aoe.Y20.Day11 do
  alias Aoe.Input, warn: false
  import Enum, only: [with_index: 1]

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    file
    |> Input.stream_file_lines(trim: true)
    |> Enum.to_list()
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
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
    |> length
  end

  defp reduce_map_p1(map) do
    new_map =
      Enum.reduce(map, map, fn {coords, val}, new_map ->
        neighb_count =
          Map.take(map, neighbours_keys(coords))
          |> Enum.filter(fn
            {{_, _}, ?#} -> true
            _ -> false
          end)
          |> length

        case {val, neighb_count} do
          {?L, 0} -> Map.put(new_map, coords, ?#)
          {?#, n} when n >= 4 -> Map.put(new_map, coords, ?L)
          _ -> new_map
        end
      end)

    if new_map == map do
      new_map
    else
      reduce_map_p1(new_map)
    end
  end

  defp neighbours_keys({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
  end

  def part_two({width, height, map}) do
    max_x = width - 1
    max_y = height - 1

    map
    |> reduce_map_p2(max_x, max_y)
    |> Enum.filter(fn {_, val} -> val == ?# end)
    |> length
  end

  defp reduce_map_p2(map, max_x, max_y) do
    new_map =
      Enum.reduce(map, map, fn {coords, val}, new_map ->
        neighb_count = trace_rays(map, coords, max_x, max_y)
        # neighb_count |> IO.inspect(label: "neighb_count")

        case {val, neighb_count} do
          {?L, 0} -> Map.put(new_map, coords, ?#)
          {?#, n} when n >= 5 -> Map.put(new_map, coords, ?L)
          _ -> new_map
        end
      end)

    if new_map == map do
      new_map
    else
      reduce_map_p2(new_map, max_x, max_y)
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

  def trace_ray(map, {x, y}, {add_x, add_y} = add, max_x, max_y) do
    0
  end
end
