defmodule AdventOfCode.Y22.Day15 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("Sensor at " <> line) do
    [sensor, beacon] = String.split(line, ": closest beacon is at ")
    {coords_to_tuple(sensor), coords_to_tuple(beacon)}
  end

  defp coords_to_tuple("x=" <> x_and_rest) do
    [x, y] = String.split(x_and_rest, ", y=")
    {String.to_integer(x), String.to_integer(y)}
  end

  def part_one(data, check_y \\ 2_000_000) do
    sensor_rays = Enum.map(data, fn {sensor, beacon} -> {sensor, manhattan(sensor, beacon)} end)

    ranges =
      Enum.map(sensor_rays, fn sens_ray -> {sens_ray, row_coverage(sens_ray, check_y)} end)
      |> Enum.filter(&(elem(&1, 1) != :empty))
      |> Enum.map(&elem(&1, 1))
      |> collapse_ranges()

    coverage =
      ranges
      |> Enum.reduce(0, fn range, acc -> acc + Range.size(range) end)

    subtract_beacons =
      Enum.filter(data, fn {_, {_, y}} -> y == check_y end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.uniq()
      |> Enum.count(fn {_, bcn_y} ->
        Enum.any?(ranges, &(bcn_y in &1))
      end)

    coverage - subtract_beacons
  end

  def part_two(data, max_bound \\ 4_000_000) do
    square = {{0, 0}, {max_bound, max_bound}}
    sensor_rays = Enum.map(data, fn {sensor, beacon} -> {sensor, manhattan(sensor, beacon)} end)

    {x, y} = find_point([square], sensor_rays)
    x * 4_000_000 + y
  end

  defp manhattan({x, y}, {ax, ay}) do
    abs(x - ax) + abs(y - ay)
  end

  defp row_coverage({{x, y}, range}, line) do
    vertical_path_len = abs(line - y)

    if vertical_path_len > range do
      :empty
    else
      (x - (range - vertical_path_len))..(x + (range - vertical_path_len))
    end
  end

  defp collapse_ranges(ranges) do
    collapse_ranges(ranges, [])
  end

  defp collapse_ranges([r | ranges], acc) do
    case Enum.find(acc, &(not Range.disjoint?(&1, r))) do
      nil ->
        collapse_ranges(ranges, [r | acc])

      overlaping ->
        collapse_ranges([merge_range(r, overlaping) | (acc -- [overlaping]) ++ ranges])
    end
  end

  defp collapse_ranges([], acc) do
    acc
  end

  defp merge_range(al..ah, bl..bh) when bl >= al and bl <= ah and bh > ah do
    al..bh
  end

  defp merge_range(al..ah, bl..bh) when al >= bl and al <= bh and ah > bh do
    bl..ah
  end

  defp merge_range(al..ah, bl..bh) when bl >= al and bh <= ah do
    al..ah
  end

  defp merge_range(al..ah, bl..bh) when al >= bl and ah <= bh do
    bl..bh
  end

  defp find_point([{{xl, yl}, {xh, yh}} = square | squares], rays) do
    covered? =
      Enum.any?(rays, fn {xy_sensor, range} ->
        manhattan(xy_sensor, {xl, yl}) <= range and
          manhattan(xy_sensor, {xh, yl}) <= range and
          manhattan(xy_sensor, {xl, yh}) <= range and
          manhattan(xy_sensor, {xh, yh}) <= range
      end)

    cond do
      covered? ->
        find_point(squares, rays)

      point?(square) ->
        square_to_point(square)

      true ->
        # if the square is not covered, we split it in four squares

        add =
          square
          |> split_vertically()
          |> Enum.flat_map(&split_horizontally(&1))

        new_squares = add ++ squares

        find_point(new_squares, rays)
    end
  end

  defp point?({xy, xy}) do
    true
  end

  defp point?(_) do
    false
  end

  defp square_to_point({xy, _}) do
    xy
  end

  defp split_vertically({{xl, yl}, {xh, yh}}) when xh > xl + 1 do
    half_x = middle(xl, xh)
    [{{xl, yl}, {half_x, yh}}, {{half_x + 1, yl}, {xh, yh}}]
  end

  defp split_vertically({{xl, yl}, {xh, yh}}) when xh == xl + 1 do
    [{{xl, yl}, {xl, yh}}, {{xh, yl}, {xh, yh}}]
  end

  defp split_vertically({{x, _}, {x, _}} = square) do
    [square]
  end

  defp split_horizontally({{xl, yl}, {xh, yh}}) when yh > yl + 1 do
    half_y = middle(yl, yh)
    [{{xl, yl}, {xh, half_y}}, {{xl, half_y + 1}, {xh, yh}}]
  end

  defp split_horizontally({{xl, yl}, {xh, yh}}) when yh == yl + 1 do
    [{{xl, yl}, {xh, yl}}, {{xl, yh}, {xh, yh}}]
  end

  defp split_horizontally({{_, y}, {_, y}} = square) do
    [square]
  end

  defp middle(low, high) do
    high - div(high - low, 2)
  end
end
