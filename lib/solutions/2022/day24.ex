defmodule AdventOfCode.Y22.Day24 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, y} -> parse_line(line, y) end)
    |> Map.new()
  end

  defp parse_line(line, y) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(fn {c, x} ->
      case parse_cell(c) do
        nil -> []
        c -> [{{x, y}, c}]
      end
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp parse_cell(t) do
    case t do
      "." -> nil
      "^" -> :b_up
      ">" -> :b_right
      "v" -> :b_down
      "<" -> :b_left
      "#" -> :wall
    end
  end

  def part_one(map) do
    keys = Map.keys(map)
    xl = min_x(keys)
    xh = max_x(keys)
    yl = min_y(keys)
    yh = max_y(keys)

    bounds = {xl, xh, yl, yh}
    blizz_bounds = {xl + 1, xh - 1, yl + 1, yh - 1}

    init_pos = {xl + 1, yl}
    false = Map.has_key?(map, init_pos)
    end_pos = {xh - 1, yh}
    false = Map.has_key?(map, init_pos)

    run_path_p1(map, bounds, blizz_bounds, [init_pos], end_pos, 0)
  end

  defp run_path_p1(map, bounds, blizz_bounds, poses, end_pos, rounds) when rounds < 2000 do
    map = move_blizzards(map, blizz_bounds)

    new_poses =
      poses
      |> Enum.flat_map(&cardinal_and_wait/1)
      |> Enum.uniq()
      |> Enum.filter(&(in_bounds?(&1, bounds) and not Map.has_key?(map, &1)))

    rounds = rounds + 1

    if end_pos in new_poses do
      rounds
    else
      run_path_p1(map, bounds, blizz_bounds, new_poses, end_pos, rounds)
    end
  end

  def part_two(map) do
    keys = Map.keys(map)
    xl = min_x(keys)
    xh = max_x(keys)
    yl = min_y(keys)
    yh = max_y(keys)

    bounds = {xl, xh, yl, yh}
    blizz_bounds = {xl + 1, xh - 1, yl + 1, yh - 1}

    init_pos = {xl + 1, yl}
    false = Map.has_key?(map, init_pos)
    end_pos = {xh - 1, yh}
    target_poses = [end_pos, init_pos, end_pos]
    false = Map.has_key?(map, init_pos)

    run_path_p2(map, bounds, blizz_bounds, [init_pos], target_poses, 0)
  end

  defp run_path_p2(
         map,
         bounds,
         blizz_bounds,
         poses,
         [target | target_rest] = target_poses,
         rounds
       ) do
    map = move_blizzards(map, blizz_bounds)

    new_poses =
      poses
      |> Enum.flat_map(&cardinal_and_wait/1)
      |> Enum.uniq()
      |> Enum.filter(&(in_bounds?(&1, bounds) and not Map.has_key?(map, &1)))

    rounds = rounds + 1

    if target in new_poses do
      run_path_p2(map, bounds, blizz_bounds, [target], target_rest, rounds)
    else
      run_path_p2(map, bounds, blizz_bounds, new_poses, target_poses, rounds)
    end
  end

  defp run_path_p2(_, _, _, _, [] = _target_poses, rounds) do
    rounds
  end

  defp move_blizzards(map, blizz_bounds) do
    for {xy, blizzs} <- map, blizz <- blizzs, reduce: %{} do
      acc ->
        case blizz do
          :wall ->
            Map.put(acc, xy, [:wall])

          _ ->
            next_xy = xy |> translate(blizz) |> wrap_bounds(blizz_bounds, blizz)

            case Map.fetch(acc, next_xy) do
              {:ok, list} -> Map.put(acc, next_xy, [blizz | list])
              :error -> Map.put(acc, next_xy, [blizz])
            end
        end
    end
  end

  defp translate({x, y}, :b_up), do: {x, y - 1}
  defp translate({x, y}, :b_down), do: {x, y + 1}
  defp translate({x, y}, :b_left), do: {x - 1, y}
  defp translate({x, y}, :b_right), do: {x + 1, y}

  defp cardinal_and_wait(xy) do
    [
      xy,
      translate(xy, :b_up),
      translate(xy, :b_down),
      translate(xy, :b_left),
      translate(xy, :b_right)
    ]
  end

  defp wrap_bounds({x, y}, {xl, xh, _yl, _yh}, :b_right) when x > xh do
    {xl, y}
  end

  defp wrap_bounds({x, y}, {xl, xh, _yl, _yh}, :b_left) when x < xl do
    {xh, y}
  end

  defp wrap_bounds({x, y}, {_xl, _xh, yl, yh}, :b_down) when y > yh do
    {x, yl}
  end

  defp wrap_bounds({x, y}, {_xl, _xh, yl, yh}, :b_up) when y < yl do
    {x, yh}
  end

  defp wrap_bounds({x, y}, _, _) do
    {x, y}
  end

  defp in_bounds?({x, y}, {xl, xh, yl, yh}) do
    x >= xl and x <= xh and y >= yl and y <= yh
  end

  defp max_x({a, _}, {b, _}), do: max(a, b)
  defp max_x({a, _}, b) when is_integer(b), do: max(a, b)
  defp min_x({a, _}, {b, _}), do: min(a, b)
  defp min_x({a, _}, b) when is_integer(b), do: min(a, b)
  defp max_y({_, a}, {_, b}), do: max(a, b)
  defp max_y({_, a}, b) when is_integer(b), do: max(a, b)
  defp min_y({_, a}, {_, b}), do: min(a, b)
  defp min_y({_, a}, b) when is_integer(b), do: min(a, b)

  defp max_x(list) when is_list(list), do: Enum.reduce(list, &max_x/2)
  defp min_x(list) when is_list(list), do: Enum.reduce(list, &min_x/2)
  defp max_y(list) when is_list(list), do: Enum.reduce(list, &max_y/2)
  defp min_y(list) when is_list(list), do: Enum.reduce(list, &min_y/2)
end
