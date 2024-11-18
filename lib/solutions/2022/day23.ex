defmodule AdventOfCode.Solutions.Y22.Day23 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
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
    |> Enum.filter(fn {d, _} -> d == "#" end)
    |> Enum.map(fn {"#", x} -> {{x, y}, :elf} end)
  end

  def part_one(map) do
    {map, _} =
      play_rounds(map, 1, 10, [[:n, :ne, :nw], [:s, :se, :sw], [:w, :nw, :sw], [:e, :ne, :se]])

    count_grounds(map)
  end

  def part_two(map) do
    {_, round} =
      play_rounds(map, 1, :infinity, [
        [:n, :ne, :nw],
        [:s, :se, :sw],
        [:w, :nw, :sw],
        [:e, :ne, :se]
      ])

    round
  end

  defp play_rounds(map, round, max_round, _) when round > max_round do
    {map, round}
  end

  defp play_rounds(map, round, max_round, [first_check | rest] = move_orders) do
    {map, count} = play_round(map, move_orders)

    case count do
      0 -> {map, round}
      _ -> play_rounds(map, round + 1, max_round, rest ++ [first_check])
    end
  end

  defp play_round(map, move_orders) when is_map(map) do
    movable_elfs = elfs_that_will_move(map)

    actual_moves =
      movable_elfs
      |> Enum.flat_map(&get_proposal(&1, map, move_orders))
      |> Enum.group_by(fn {:from, _, :to, next} -> next end)
      |> Enum.filter(fn
        {_, [_single]} -> true
        _ -> false
      end)
      |> Enum.map(fn {_, [v]} -> v end)

    move_count = length(actual_moves)

    {run_moves(map, actual_moves), move_count}
  end

  defp run_moves(map, moves) do
    Enum.reduce(moves, map, fn {:from, elf_xy, :to, next}, map ->
      {elf, map} = Map.pop!(map, elf_xy)
      Map.put(map, next, elf)
    end)
  end

  defp elfs_that_will_move(map) do
    keys = Map.keys(map)
    Enum.filter(keys, &has_neighs?(&1, map))
  end

  defp has_neighs?(xy, map) do
    neighs = cardinal8(xy)
    Enum.any?(neighs, &Map.has_key?(map, &1))
  end

  defp cardinal8(xy) do
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

  defp translate({x, y}, :n), do: {x, y - 1}
  defp translate({x, y}, :ne), do: {x + 1, y - 1}
  defp translate({x, y}, :nw), do: {x - 1, y - 1}
  defp translate({x, y}, :s), do: {x, y + 1}
  defp translate({x, y}, :se), do: {x + 1, y + 1}
  defp translate({x, y}, :sw), do: {x - 1, y + 1}
  defp translate({x, y}, :w), do: {x - 1, y}
  defp translate({x, y}, :e), do: {x + 1, y}

  defp get_proposal(elf, map, [move_order | move_orders]) do
    [new_xy | _] = check_xys = Enum.map(move_order, &translate(elf, &1))

    if Enum.all?(check_xys, &(not Map.has_key?(map, &1))) do
      [{:from, elf, :to, new_xy}]
    else
      get_proposal(elf, map, move_orders)
    end
  end

  defp get_proposal(_, _map, []) do
    []
  end

  defp get_bounds(map) do
    keys = Map.keys(map)

    {min_x(keys), max_x(keys), min_y(keys), max_y(keys)}
  end

  defp count_grounds(map) do
    {xl, xh, yl, yh} = get_bounds(map)

    (xh - xl + 1) * (yh - yl + 1) - map_size(map)
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
