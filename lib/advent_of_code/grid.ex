defmodule AdventOfCode.Grid do
  def parse_lines(lines, char_parser)
      when is_function(char_parser, 1)
      when is_function(char_parser, 2) do
    {max_x, max_y, rows, meta} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({0, 0, [], _meta = %{}}, fn
        {<<>>, _}, acc ->
          acc

        {line, y}, {max_x, _max_y, acc, meta} ->
          {best_x, pairs, meta} = parse_bin_line(line, y, char_parser, meta)
          {max(max_x, best_x), y, [pairs | acc], meta}
      end)

    {Map.new(:lists.flatten(rows)), {0, max_x, 0, max_y}, meta}
  end

  defp parse_bin_line(string, y, parse_char, meta) do
    {high_x, pairs, meta} =
      for <<c::utf8 <- string>>, c != ?\n, reduce: {0, [], meta} do
        {x, row, meta} ->
          case call_parser(parse_char, {x, y}, c) do
            :ignore ->
              {x + 1, row, meta}

            {:ok, v} ->
              {x + 1, [{{x, y}, v} | row], meta}

            {:ok, v, add_meta} ->
              {x + 1, [{{x, y}, v} | row], Map.merge(meta, Map.new(add_meta))}

            other ->
              raise "Invalid return value from parser function in AdventOfCode.Grid.parse_lines/2, expected {:ok, value} or :ignore, got: #{inspect(other)}"
          end
      end

    {high_x - 1, pairs, meta}
  end

  defp call_parser(parser, xy, c) when is_function(parser, 2) do
    parser.(xy, c)
  rescue
    _ in FunctionClauseError ->
      reraise RuntimeError,
              [
                message: "grid parser did not accept the arguments (#{inspect(xy)}, ?#{<<c::utf8>>})"
              ],
              __STACKTRACE__
  end

  defp call_parser(parser, _xy, c) when is_function(parser, 1) do
    parser.(c)
  rescue
    _ in FunctionClauseError ->
      reraise RuntimeError,
              [
                message: "grid parser did not accept the arguments (?#{<<c::utf8>>})"
              ],
              __STACKTRACE__
  end

  def min_x(list) when is_list(list), do: Enum.reduce(list, &min_x/2)
  def min_x(map) when is_map(map), do: map |> Map.keys() |> min_x()

  def max_x(map) when is_map(map), do: map |> Map.keys() |> max_x()
  def max_x(list) when is_list(list), do: Enum.reduce(list, &max_x/2)

  def min_y(map) when is_map(map), do: map |> Map.keys() |> min_y()
  def min_y(list) when is_list(list), do: Enum.reduce(list, &min_y/2)

  def max_y(map) when is_map(map), do: map |> Map.keys() |> max_y()
  def max_y(list) when is_list(list), do: Enum.reduce(list, &max_y/2)

  def max_x({a, _}, {b, _}), do: max(a, b)
  def max_x({a, _}, b) when is_integer(b), do: max(a, b)
  def min_x({a, _}, {b, _}), do: min(a, b)
  def min_x({a, _}, b) when is_integer(b), do: min(a, b)
  def max_y({_, a}, {_, b}), do: max(a, b)
  def max_y({_, a}, b) when is_integer(b), do: max(a, b)
  def min_y({_, a}, {_, b}), do: min(a, b)
  def min_y({_, a}, b) when is_integer(b), do: min(a, b)

  @doc """
  Returns {min_x, max_x, min_y, max_y} for the given map.

      {xa, xo, ya, yo} = Grid.bounds(grid)
  """
  def bounds(map) when map_size(map) == 1 do
    [{x, y}] = Map.keys(map)
    {x, x, y, y}
  end

  def bounds(map) when is_map(map) do
    keys = Map.keys(map)
    {min_x(keys), max_x(keys), min_y(keys), max_y(keys)}
  end

  @deprecated "use format/2"
  def format_map(map, print_char \\ &self_char/1) do
    format(map, print_char)
  end

  def format(grid, print_char \\ &self_char/1) do
    {xl, xh, yl, yh} = bounds(grid)

    for y <- yl..yh do
      [
        "\n",
        for x <- xl..xh do
          print_char.(Map.get(grid, {x, y}))
        end
      ]
    end
  end

  @deprecated "use print/2"
  def print_map(map, print_char \\ &self_char/1) do
    print(map, print_char)
  end

  def print(grid, print_char \\ &self_char/1) do
    IO.puts(format(grid, print_char))

    grid
  end

  defp self_char(nil), do: " "
  defp self_char(<<a>>), do: a

  def bfs_path(map, start_pos, end_pos, get_neighs) do
    bfs_path(
      map,
      [start_pos],
      end_pos,
      get_neighs,
      _round = 1,
      _seen = %{start_pos => true}
    )
  catch
    {:found, path} -> {:ok, path}
    :not_found -> {:error, :no_path}
  end

  defp bfs_path(map, [_ | _] = open, end_pos, get_neighs, round, seen) do
    neighs =
      open
      |> Enum.flat_map(fn pos -> get_neighs.(pos, map) end)
      |> Enum.uniq()
      |> Enum.filter(&(not Map.has_key?(seen, &1)))

    if end_pos in neighs do
      throw({:found, round})
    end

    seen = Map.merge(seen, Map.new(neighs, &{&1, true}))

    bfs_path(map, neighs, end_pos, get_neighs, round + 1, seen)
  end

  defp bfs_path(_, [], _, _, _, _) do
    throw(:not_found)
  end

  def cardinal4(xy) do
    [
      translate(xy, :n),
      translate(xy, :s),
      translate(xy, :w),
      translate(xy, :e)
    ]
  end

  def cardinal8(xy) do
    [
      translate(xy, :n),
      translate(xy, :nw),
      translate(xy, :ne),
      translate(xy, :s),
      translate(xy, :se),
      translate(xy, :sw),
      translate(xy, :w),
      translate(xy, :e)
    ]
  end

  def directions(4), do: [:n, :s, :w, :e]
  def directions(8), do: [:n, :s, :w, :e, :ne, :nw, :se, :sw]

  def translate(xy, direction, n \\ 1)
  def translate({x, y}, :n, n), do: {x, y - n}
  def translate({x, y}, :ne, n), do: {x + n, y - n}
  def translate({x, y}, :nw, n), do: {x - n, y - n}
  def translate({x, y}, :s, n), do: {x, y + n}
  def translate({x, y}, :se, n), do: {x + n, y + n}
  def translate({x, y}, :sw, n), do: {x - n, y + n}
  def translate({x, y}, :w, n), do: {x - n, y}
  def translate({x, y}, :e, n), do: {x + n, y}

  def rotate_clockwise(:n), do: :e
  def rotate_clockwise(:e), do: :s
  def rotate_clockwise(:s), do: :w
  def rotate_clockwise(:w), do: :n
  def rotate_counter_clockwise(:n), do: :w
  def rotate_counter_clockwise(:w), do: :s
  def rotate_counter_clockwise(:s), do: :e
  def rotate_counter_clockwise(:e), do: :n

  def which_direction({x1, y}, {x2, y}) when x2 == x1 - 1, do: :w
  def which_direction({x1, y}, {x2, y}) when x2 == x1 + 1, do: :e
  def which_direction({x, y1}, {x, y2}) when y2 == y1 - 1, do: :n
  def which_direction({x, y1}, {x, y2}) when y2 == y1 + 1, do: :s
end
