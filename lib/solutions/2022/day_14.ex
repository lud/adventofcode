defmodule Aoe.Y22.Day14 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> Enum.flat_map(&parse_line/1)
    |> Enum.reduce(%{}, &add_rock/2)
  end

  defp add_rock(point, map) do
    Map.put(map, point, :rock)
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&parse_point/1)
    |> Enum.reduce(&expand_path/2)
  end

  defp parse_point(str) do
    [a, b] = String.split(str, ",")
    {String.to_integer(a), String.to_integer(b)}
  end

  defp expand_path(same, [same | _] = acc) do
    acc
  end

  defp expand_path({x, y_next}, [{x, y_cur} | _] = acc) when y_cur < y_next do
    expand_path({x, y_next}, [{x, y_cur + 1} | acc])
  end

  defp expand_path({x, y_next}, [{x, y_cur} | _] = acc) when y_cur > y_next do
    expand_path({x, y_next}, [{x, y_cur - 1} | acc])
  end

  defp expand_path({x_next, y}, [{x_cur, y} | _] = acc) when x_cur < x_next do
    expand_path({x_next, y}, [{x_cur + 1, y} | acc])
  end

  defp expand_path({x_next, y}, [{x_cur, y} | _] = acc) when x_cur > x_next do
    expand_path({x_next, y}, [{x_cur - 1, y} | acc])
  end

  defp expand_path({_, _} = second, {_, _} = first) do
    expand_path(second, [first])
  end

  def part_one(map) do
    yh = Map.keys(map) |> Enum.max_by(&elem(&1, 1)) |> elem(1)
    map = pour_sand(map, yh + 1)
    map |> Map.values() |> Enum.filter(&(&1 == :sand)) |> Enum.count()
  end

  def part_two_alt(map) do
    yh = Map.keys(map) |> Enum.max_by(&elem(&1, 1)) |> elem(1)
    map = pour_sand_2(map, yh + 2)
    map |> Map.values() |> Enum.filter(&(&1 == :sand)) |> Enum.count()
  end

  defp pour_sand(map, void) do
    pour_sand(map, {500, 0}, void)
  end

  defp pour_sand(map, xy, void) do
    below = below(xy)
    bleft = below(left(xy))
    bright = below(right(xy))

    cond do
      elem(xy, 1) == void -> map
      free?(map, below) -> pour_sand(map, below, void)
      free?(map, bleft) -> pour_sand(map, bleft, void)
      free?(map, bright) -> pour_sand(map, bright, void)
      true -> map |> Map.put(xy, :sand) |> pour_sand(void)
    end
  end

  defp pour_sand_2(map, bedrock) do
    pour_sand_2(map, {500, 0}, bedrock)
  end

  defp pour_sand_2(map, xy, bedrock) do
    below = below(xy)
    bleft = below(left(xy))
    bright = below(right(xy))

    cond do
      free?(map, below, bedrock) -> pour_sand_2(map, below, bedrock)
      free?(map, bleft, bedrock) -> pour_sand_2(map, bleft, bedrock)
      free?(map, bright, bedrock) -> pour_sand_2(map, bright, bedrock)
      xy == {500, 0} -> map |> Map.put(xy, :sand)
      :_ -> map |> Map.put(xy, :sand) |> pour_sand_2(bedrock)
    end
  end

  defp free?(map, xy) do
    not Map.has_key?(map, xy)
  end

  defp free?(_, {_, bedrock}, bedrock) do
    false
  end

  defp free?(map, xy, _) do
    free?(map, xy)
  end

  defp below({x, y}) do
    {x, y + 1}
  end

  defp left({x, y}) do
    {x - 1, y}
  end

  defp right({x, y}) do
    {x + 1, y}
  end

  defp top_left({x, y}) do
    {x - 1, y - 1}
  end

  defp top_right({x, y}) do
    {x + 1, y - 1}
  end

  defp top({x, y}) do
    {x, y - 1}
  end

  def part_two(map) do
    yh = Map.keys(map) |> Enum.max_by(&elem(&1, 1)) |> elem(1)

    bottom = yh + 1

    points =
      for y <- 0..bottom, x <- (500 - y)..(500 + y) do
        {x, y}
      end

    places = length(points)

    map =
      Enum.reduce(points, map, fn xy, map ->
        case Map.get(map, xy, :void) do
          :rock ->
            map

          :void when xy == {500, 0} ->
            map

          :source ->
            map

          :void ->
            parents = get_parents(xy)

            if all_blocked?(parents, map) do
              Map.put(map, xy, :shadow)
            else
              map
            end
        end
      end)

    blocked =
      Enum.reduce(map, 0, fn {_, kind}, acc ->
        case kind do
          :rock -> acc + 1
          :shadow -> acc + 1
          _ -> acc
        end
      end)

    places - blocked
  end

  defp get_parents({_, 0}) do
    []
  end

  defp get_parents({x, y} = xy) do
    cond do
      x == 500 - y -> [top_right(xy)]
      x == 500 + y -> [top_left(xy)]
      true -> [top_left(xy), top(xy), top_right(xy)]
    end
  end

  defp all_blocked?([], _map) do
    true
  end

  defp all_blocked?(parents, map) do
    Enum.all?(parents, fn p -> blocked?(map, p) end)
  end

  defp blocked?(map, {x, y} = xy) do
    v = Map.get(map, xy)

    cond do
      v == :rock -> true
      v == :shadow -> true
      x < 500 - y -> true
      x > 500 + y -> true
      true -> false
    end
  end
end
