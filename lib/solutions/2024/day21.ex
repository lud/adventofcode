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
      low = find_best_moves(code)
      figure = code |> Enum.filter(&is_integer/1) |> Integer.undigits()
      figure * low
    end)
    |> Enum.sum()
  end

  defp count_moves(list, acc \\ 0)
  defp count_moves([{_, n} | t], acc), do: count_moves(t, acc + n)
  defp count_moves([], acc), do: acc

  defp find_best_moves(door_code) do
    digits_to_controls(door_code)
  end

  defp digits_to_controls(door_code) do
    movesets = Enum.chunk_every([:A | door_code], 2, 1, :discard)

    movesets
    |> Enum.map(fn [a, b] = _move ->

      for dirkeys1 <- controls_for_digit_press(a, b),
          dirkeys2 <- controls_for_controls_press(dirkeys1),
          dirkeys3 <- controls_for_controls_press(dirkeys2),
          reduce: {nil, :infinity} do
        {best, best_size} ->
          score = count_moves(dirkeys3)

          if score < best_size do
            {dirkeys3, score}
          else
            {best, best_size}
          end
      end
      |> elem(1)
    end)
    |> Enum.sum()
  end

  defp controls_for_digit_press(a, b) do
    digit_moves_combinations(a, b)
  end

  defp controls_for_controls_press(dirkeys) do
    initial_pos = :A

    Enum.reduce(dirkeys, [{initial_pos, []}], fn {key, repeat}, states ->
      Enum.flat_map(states, fn {current_pos, rev_path} ->
        possible_moves = control_moves_combinations(current_pos, key, repeat)
        Enum.map(possible_moves, fn moves -> {_new_current = key, [moves | rev_path]} end)
      end)
    end)
    |> Enum.map(fn {_last_pos, rev_path} -> rev_path |> :lists.reverse() |> Enum.flat_map(& &1) end)
  end

  defp digit_moves_combinations(from, to) do
    base_moves = path_digit_to_digit(from, to)

    base_moves
    |> combinations_add_press()
    |> Enum.filter(&legal?(from, &1))
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
    |> Enum.filter(&legal?(from, &1))
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
  defp combinations_add_press([], _), do: raise("pouet")
  defp combinations_add_press([single], n_press), do: [[single, {:A, n_press}]]
  defp combinations_add_press([a, b], n_press), do: [[a, b, {:A, n_press}], [b, a, {:A, n_press}]]

  defp legal?(start_pos, moves) when (is_atom(start_pos) or is_integer(start_pos)) and is_list(moves) do
    is? = _legal?(start_pos, hd(moves))
    # IO.puts("LEGAL FROM  #{fmt(start_pos)} ? [#{fmt(moves)}] : #{is?}")
    is?
  end

  defp _legal?(0, {:<, _}), do: false
  defp _legal?(1, {:v, _}), do: false
  defp _legal?(4, {:v, n}) when n > 1, do: false
  defp _legal?(7, {:v, n}) when n > 2, do: false
  defp _legal?(:<, {:^, _}), do: false
  defp _legal?(:^, {:<, _}), do: false
  defp _legal?(:A, {:<, 2}), do: false
  defp _legal?(c, _move) when is_atom(c), do: true
  defp _legal?(n, _move) when is_integer(n), do: true

  defp fmt({c, n}) when c in [:A, :<, :>, :^, :v], do: List.duplicate(Atom.to_string(c), n)
  defp fmt(c) when c in [:A, :<, :>, :^, :v], do: Atom.to_string(c)
  defp fmt([h | t]), do: [fmt(h) | fmt(t)]
  defp fmt([]), do: []
  defp fmt(n) when is_integer(n), do: Integer.to_string(n)

  defp io_fmt(v) do
    IO.puts(["MOV: ", fmt(v)])
    v
  end
end
