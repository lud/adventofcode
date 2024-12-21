defmodule AdventOfCode.Solutions.Y24.Day21 do
  alias AdventOfCode.Grid
  alias AoC.Input

  flip_map = fn grid -> Map.new(grid, fn {k, v} -> {v, k} end) end

  compute_coordinates = fn text ->
    {grid, _, _} =
      text
      |> String.split("\n", trim: true)
      |> Grid.parse_lines(fn
        c when c in ?0..?9 -> {:ok, c - ?0}
        ?A -> {:ok, :A}
        ?^ -> {:ok, :^}
        ?< -> {:ok, :<}
        ?v -> {:ok, :v}
        ?> -> {:ok, :>}
        ?A -> {:ok, :A}
        ?\s -> :ignore
      end)

    flip_map.(grid)
  end

  @digit_coords compute_coordinates.("""
                789
                456
                123
                 0A
                """)

  @directional_coords compute_coordinates.("""
                       ^A
                      <v>
                      """)

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn
      "A" -> :A
      n -> String.to_integer(n)
    end)
  end

  def part_one(door_codes) do
    solve(door_codes, 2 + 1)
  end

  def part_two(door_codes) do
    solve(door_codes, 25 + 1)
  end

  defp solve(door_codes, levels) do
    Enum.map(door_codes, fn code ->
      low = shortest_digit_move_count(code, levels)
      figure = code |> Enum.filter(&is_integer/1) |> Integer.undigits()
      figure * low
    end)
    |> Enum.sum()
  end

  defp count_moves(list, acc \\ 0)
  defp count_moves([{_, n} | t], acc), do: count_moves(t, acc + n)
  defp count_moves([], acc), do: acc

  defp shortest_digit_move_count(door_code, level) do
    movesets = Enum.chunk_every([:A | door_code], 2, 1, :discard)

    Enum.sum_by(movesets, fn [a, b] ->
      combis = digit_moves_combinations(a, b)
      best_submoves(combis, level)
    end)
  end

  defp shortest_controls_move_count(dirkeys, 0) do
    count_moves(dirkeys)
  end

  defp shortest_controls_move_count(dirkeys, level) do
    memoized({dirkeys, level}, fn ->
      movesets = Enum.chunk_every([{:A, :unused} | dirkeys], 2, 1, :discard)

      Enum.sum_by(movesets, fn [{a, _}, {b, presscount}] ->
        combis = control_moves_combinations(a, b, presscount)
        best_submoves(combis, level)
      end)
    end)
  end

  defp best_submoves(combinations, level) do
    Enum.reduce(combinations, :infinity, fn
      submoves, best -> min(best, shortest_controls_move_count(submoves, level - 1))
    end)
  end

  defp memoized(key, fun) do
    pkey = {__MODULE__, key}

    case Process.get(pkey, nil) do
      nil ->
        value = fun.()
        Process.put(pkey, value)
        value

      value ->
        value
    end
  end

  defp digit_moves_combinations(from, to) do
    base_moves = path_digit_to_digit(from, to)

    base_moves
    |> combinations_add_press()
    |> Enum.filter(&legal?(from, hd(&1)))
  end

  defp path_digit_to_digit(a, b) do
    ca = Map.fetch!(@digit_coords, a)
    cb = Map.fetch!(@digit_coords, b)
    get_moves(ca, cb)
  end

  defp control_moves_combinations(from, to, presscount) do
    base_moves = path_control_to_control(from, to)

    base_moves
    |> combinations_add_press(presscount)
    |> Enum.filter(&legal?(from, hd(&1)))
  end

  defp path_control_to_control(a, b) do
    ca = Map.fetch!(@directional_coords, a)
    cb = Map.fetch!(@directional_coords, b)

    get_moves(ca, cb)
  end

  # moves from one coordinate to another, regardless of void spaces
  defp get_moves({x, y}, {x, y}), do: []
  defp get_moves({x, y1}, {x, y2}) when y2 > y1, do: [{:v, y2 - y1}]
  defp get_moves({x, y1}, {x, y2}) when y2 < y1, do: [{:^, y1 - y2}]
  defp get_moves({x1, y}, {x2, y}) when x2 > x1, do: [{:>, x2 - x1}]
  defp get_moves({x1, y}, {x2, y}) when x2 < x1, do: [{:<, x1 - x2}]

  defp get_moves({x1, y1}, {x2, y2}),
    do: get_moves({x1, y1}, {_copy_x = x1, y2}) ++ get_moves({x1, y1}, {x2, _copy_y = y1})

  defp combinations_add_press(moves, add_a \\ 1)
  defp combinations_add_press([single], n_press), do: [[single, {:A, n_press}]]
  defp combinations_add_press([a, b], n_press), do: [[a, b, {:A, n_press}], [b, a, {:A, n_press}]]

  defp legal?(0, {:<, _}), do: false
  defp legal?(1, {:v, _}), do: false
  defp legal?(4, {:v, n}) when n > 1, do: false
  defp legal?(7, {:v, n}) when n > 2, do: false
  defp legal?(:<, {:^, _}), do: false
  defp legal?(:^, {:<, _}), do: false
  defp legal?(:A, {:<, 2}), do: false
  defp legal?(c, _move) when is_atom(c), do: true
  defp legal?(n, _move) when is_integer(n), do: true
end
