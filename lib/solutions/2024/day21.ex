defmodule AdventOfCode.Solutions.Y24.Day21 do
  alias AdventOfCode.Grid
  alias AoC.Input

  flip_grid = fn {grid, _, _} -> Map.new(grid, fn {k, v} -> {v, k} end) end

  @digit_coords """
                789
                456
                123
                 0A
                """
                |> String.split("\n", trim: true)
                |> Grid.parse_lines(fn
                  c when c in ?0..?9 -> {:ok, c - ?0}
                  ?A -> {:ok, :A}
                  ?\s -> :ignore
                end)
                |> then(flip_grid)
                |> dbg()

  @directional_coords """
                       ^A
                      <v>
                      """
                      |> String.split("\n", trim: true)
                      |> Grid.parse_lines(fn
                        ?^ -> {:ok, :^}
                        ?< -> {:ok, :<}
                        ?v -> {:ok, :v}
                        ?> -> {:ok, :>}
                        ?A -> {:ok, :A}
                        ?\s -> :ignore
                      end)
                      |> then(flip_grid)
                      |> dbg()

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
    Enum.map(door_codes, fn code ->
      IO.puts("============= #{fmt(code)}")
      low = lowest_moves(code)
      figure = code |> Enum.filter(&is_integer/1) |> Integer.undigits()
      figure |> dbg()
      presscount = count_moves(low, 0)
      presscount |> dbg()
      figure * presscount
    end)
    |> Enum.sum()
  end

  defp count_moves([{_, n} | t], acc), do: count_moves(t, acc + n)
  defp count_moves([], acc), do: acc

  defp lowest_moves(door_code) do
    door_code
    |> digits_to_directions()
  end

  # defp digits_to_directions(digits) do
  #   digits_to_directions(digits, :A)
  # end

  # defp digits_to_directions([:A], prev_pos) do
  #   print_move(prev_pos, :A)
  #   base_digit_moves = move_digit_to_digit(prev_pos, :A)

  #   best =
  #     base_digit_moves
  #     |> combinations_add_press()
  #     |> Enum.filter(&legal?(prev_pos, &1))
  #     |> Enum.map(&io_fmt/1)
  #     |> best_sub(0)
  #     |> io_fmt()
  # end

  # defp digits_to_directions([h | t], prev_pos) do
  #   print_move(prev_pos, h)
  #   # the "base" may not be legal
  #   base_digit_moves = move_digit_to_digit(prev_pos, h)

  #   best =
  #     base_digit_moves
  #     |> combinations_add_press()
  #     |> Enum.filter(&legal?(prev_pos, &1))
  #     |> Enum.map(&io_fmt/1)
  #     |> best_sub(1)
  #     |> io_fmt()

  #   best ++ digits_to_directions(t, h)
  # end

  # defp best_sub(legal_combinations, level) when level >= 0 do
  #   level |> dbg()
  #   legal_combinations |> dbg()

  #   legal_combinations
  #   |> Enum.flat_map(&directions_to_directions(&1, level - 1))
  # end

  # IO.warn("take the actual best")

  # defp best_sub(legal_combinations, -1) do
  #   hd(legal_combinations)
  # end

  # defp directions_to_directions(keys, level) do
  #   directions_to_directions(keys, :A, level)
  # end

  # defp directions_to_directions([{:press, reps}], prev_pos, level) do
  #   print_move(prev_pos, :A)

  #   # same, may not be legal
  #   base_dirpad_moves = move_dir_to_dir(prev_pos, :A)

  #   true = is_atom(prev_pos)

  #   base_dirpad_moves
  #   |> combinations_add_press(reps)
  #   |> Enum.filter(&legal?(prev_pos, &1))
  #   |> Enum.map(&io_fmt/1)
  #   |> best_sub(level)
  # end

  # defp directions_to_directions([h | t], prev_pos, level) do
  #   print_move(prev_pos, h)

  #   {dirkey, repetitions} = h
  #   # same, may not be legal
  #   base_dirpad_moves = move_dir_to_dir(prev_pos, dirkey)

  #   true = is_atom(prev_pos)

  #   best =
  #     base_dirpad_moves
  #     |> combinations_add_press(repetitions)
  #     |> Enum.filter(&legal?(prev_pos, &1))
  #     |> Enum.map(&io_fmt/1)
  #     |> best_sub(level)

  #   level |> dbg()
  #   best |> dbg()
  #   sub = directions_to_directions(t, dirkey, level)
  #   sub |> dbg()
  #   best ++ sub
  # end

  # defp move_digit_to_digit(a, b) do
  #   ca = Map.fetch!(@digit_coords, a)
  #   cb = Map.fetch!(@digit_coords, b)
  #   get_moves(ca, cb)
  # end

  # defp move_dir_to_dir(a, b) do
  #   ca = Map.fetch!(@directional_coords, a)
  #   cb = Map.fetch!(@directional_coords, b)

  #   get_moves(ca, cb)
  # end

  # # moves from one coordinate to another, regardless of void spaces
  # defp get_moves({x, y}, {x, y}), do: []
  # defp get_moves({x, y1}, {x, y2}) when y2 > y1, do: [{:v, y2 - y1}]
  # defp get_moves({x, y1}, {x, y2}) when y2 < y1, do: [{:^, y1 - y2}]
  # defp get_moves({x1, y}, {x2, y}) when x2 > x1, do: [{:>, x2 - x1}]
  # defp get_moves({x1, y}, {x2, y}) when x2 < x1, do: [{:<, x1 - x2}]

  # defp get_moves({x1, y1}, {x2, y2}),
  #   do: get_moves({x1, y1}, {_copy_x = x1, y2}) ++ get_moves({x1, y1}, {x2, _copy_y = y1})

  # defp combinations_add_press(moves, add_a \\ 1)
  # defp combinations_add_press([], _), do: raise("pouet")
  # defp combinations_add_press([single], n_press), do: [[single, {:press, n_press}]]
  # defp combinations_add_press([a, b], n_press), do: [[a, b, {:press, n_press}], [b, a, {:press, n_press}]]

  # defp legal?(start_pos, moves) when (is_atom(start_pos) or is_integer(start_pos)) and is_list(moves) do
  #   is? = _legal?(start_pos, hd(moves))
  #   IO.puts("LEGAL FROM  #{fmt(start_pos)} ? [#{fmt(moves)}] : #{is?}")
  #   is?
  # end

  # defp _legal?(0, {:<, _}), do: false
  # defp _legal?(1, {:v, _}), do: false
  # defp _legal?(4, {:v, n}) when n > 1, do: false
  # defp _legal?(7, {:v, n}) when n > 2, do: false
  # defp _legal?(:<, {:^, _}), do: false
  # defp _legal?(:^, {:<, _}), do: false
  # defp _legal?(:A, {:<, 2}), do: false
  # defp _legal?(c, move) when is_atom(c), do: true
  # defp _legal?(n, move) when is_integer(n), do: true

  # defp print_move(from, to) do
  #   IO.puts("Move from #{fmt(from)} to #{fmt(to)}")
  # end

  # defp fmt({:press, n}), do: List.duplicate("A", n)
  # defp fmt(d) when d in [:<, :>, :^, :v], do: Atom.to_string(d)
  # defp fmt({dir, n}), do: List.duplicate(Atom.to_string(dir), n)
  # defp fmt(:A), do: "A"
  # defp fmt([h | t]), do: [fmt(h) | fmt(t)]
  # defp fmt([]), do: []
  # defp fmt(n) when is_integer(n), do: Integer.to_string(n)

  # defp io_fmt(v) do
  #   IO.puts(fmt(v))
  #   v
  # end
end
