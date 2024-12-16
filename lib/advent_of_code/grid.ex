defmodule AdventOfCode.Grid do
  def parse_lines(lines, char_parser)
      when is_function(char_parser, 1)
      when is_function(char_parser, 2) do
    {max_x, max_y, rows} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({0, 0, []}, fn
        {<<>>, _}, acc ->
          acc

        {line, y}, {max_x, _max_y, acc} ->
          {best_x, pairs} = parse_bin_line(line, y, char_parser)
          {max(max_x, best_x), y, [pairs | acc]}
      end)

    {Map.new(:lists.flatten(rows)), {0, max_x, 0, max_y}}
  end

  defp parse_bin_line(string, y, parse_char) do
    {high_x, pairs} =
      for <<c::utf8 <- string>>, c != ?\n, reduce: {0, []} do
        {x, row} ->
          case call_parser(parse_char, {x, y}, c) do
            :ignore ->
              {x + 1, row}

            {:ok, v} ->
              {x + 1, [{{x, y}, v} | row]}

            other ->
              raise "Invalid return value from parser function in AdventOfCode.Grid.parse_lines/2, expected {:ok, value} or :ignore, got: #{inspect(other)}"
          end
      end

    {high_x - 1, pairs}
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

  def lowest_path(map, start_state, target_pos, callback) do
    lowest_path(map, [{start_state, 0}], target_pos, callback, _costs = %{start_state => {:start, 0}})
  end

  defp lowest_path(map, [_ | _] = open, target, callback, costs) do
    {new_open, costs} =
      open
      |> Enum.flat_map(fn {pos_state, prev_cost} -> neighbors_with_costs(pos_state, prev_cost, map, callback) end)
      |> Enum.sort_by(fn {pos_state, {prev, cost}} -> cost end)
      |> Enum.reduce({[], costs}, fn {pos_state, {prev, cost}} = arg, {new_open, costs} ->
        {_new_open, _costs} =
          result =
          case costs do
            %{^pos_state => {p, prev_cost}} when cost < prev_cost ->
              # In this case we have already seen that neighbor, but we found it
              # with a better cost. We should update all other positions that
              # have it as their "prev" so reduce their cost by the difference,
              # recursively.
              #
              # For now we will just put it again on the open list and let the
              # algorithm start over from those positions.
              IO.puts("replace #{inspect(pos_state)} with cost #{inspect(cost)}")
              {[{pos_state, cost} | new_open], %{costs | pos_state => {prev, cost}}}

            %{^pos_state => {p, prev_cost}} when cost >= prev_cost ->
              {new_open, costs}

            _ ->
              {[{pos_state, cost} | new_open], Map.put(costs, pos_state, {prev, cost})}
          end

        result
      end)

    lowest_path(map, new_open, target, callback, costs)
  end

  defp lowest_path(map, [] = open, target, callback, costs) do
    costs
    |> Enum.filter(fn {pos_state, {prev, cost}} -> target?(pos_state, target, callback) end)
    |> dbg()
    |> Enum.map(fn {pos_state, {_, cost}} = target -> {pos_state, cost, rebuild_path(target, costs)} end)
    |> dbg()
    |> Enum.sort_by(fn {pos_state, cost, _path} -> cost end)
  end

  defp rebuild_path({pos_state, {prev, cost}}, costs) do
    [pos_state | do_rebuild_path(prev, costs)]
  end

  defp do_rebuild_path(:start, costs) do
    []
  end

  defp do_rebuild_path(pos_state, costs) do
    {prev, _} = Map.fetch!(costs, pos_state)
    [pos_state | do_rebuild_path(prev, costs)]
  end

  defp rebuild_cost({p, {prev, cost}}, costs) do
    {p, cost + do_rebuild_cost(prev, costs)}
  end

  defp do_rebuild_cost(pos_state, costs) do
    case Map.fetch!(costs, pos_state) do
      {:start, initial_cost} -> initial_cost
      {prev, cost} -> cost + do_rebuild_cost(prev, costs)
    end
  end

  defp dir_char(:n), do: ?^
  defp dir_char(:e), do: ?>
  defp dir_char(:w), do: ?<
  defp dir_char(:s), do: ?v
  defp dir_char(:wall), do: ?#
  defp dir_char(nil), do: ?.

  defp neighbors_with_costs(pos_state, prev_cost, map, callback) do
    neighs = callback.(:neighbors, pos_state, map)
    Enum.map(neighs, fn {neight_state, cost} -> {neight_state, {pos_state, cost + prev_cost}} end)
  end

  defp target?(pos_state, target, callback) do
    callback.(:target?, pos_state, target)
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
end
