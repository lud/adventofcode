defmodule AdventOfCode.Y22.Day22 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    [map, moves] = String.split(input, "\n\n")
    {parse_map(map), parse_moves(moves)}
  end

  defp parse_map(raw) do
    map =
      raw
      |> String.split("\n")
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        row
        |> String.graphemes()
        |> Enum.with_index(1)
        |> Enum.reduce(acc, fn {cell, x}, map -> Map.put(map, {x, y}, parse_cell(cell)) end)
      end)
      |> Map.filter(fn {_, type} -> type != :void end)

    keys = Map.keys(map)

    bounds = {
      min_x(keys),
      max_x(keys),
      min_y(keys),
      max_y(keys)
    }

    Map.put(map, :bounds, bounds)
  end

  defp parse_cell(" "), do: :void
  defp parse_cell("."), do: :ground
  defp parse_cell("#"), do: :wall

  defp parse_moves(moves) do
    moves |> String.trim() |> parse_move([]) |> :lists.reverse()
  end

  defp parse_move(rest, acc) do
    case Integer.parse(rest) do
      {n, "R" <> rest} -> parse_move(rest, [:R, {:walk, n} | acc])
      {n, "L" <> rest} -> parse_move(rest, [:L, {:walk, n} | acc])
      {n, ""} -> [{:walk, n} | acc]
    end
  end

  def part_one({map, moves}) do
    initial = %{facing: :east, pos: get_initial_pos(map)}

    state =
      Enum.reduce(moves, initial, fn move, state ->
        run_move(move, state, map)
      end)

    %{facing: facing, pos: {x, y}} = state
    y * 1000 + 4 * x + facing_score(facing)
  end

  defp facing_score(fc) do
    case fc do
      :east -> 0
      :south -> 1
      :west -> 2
      :north -> 3
    end
  end

  defp get_initial_pos(map) do
    x =
      map
      |> Enum.filter(fn
        {{_, y}, _} -> y == 1
        {:bounds, _} -> false
      end)
      |> Enum.min_by(fn {{x, _}, _} -> x end)
      |> elem(0)
      |> elem(0)

    {x, 1}
  end

  defp run_move({:walk, n}, state, map) when n > 0 do
    case next_cell(state, map) do
      {xy, :ground} -> run_move({:walk, n - 1}, put_pos(state, xy), map)
      {_, :wall} -> state
    end
  end

  defp run_move({:walk, 0}, state, _map) do
    state
  end

  defp run_move(side, state, _) when side in [:R, :L] do
    turn(state, side)
  end

  defp put_pos(state, pos) do
    %{state | pos: pos}
  end

  defp turn(%{facing: fc} = state, side) do
    new_fc = rotate_facing(fc, side)

    %{state | facing: new_fc}
  end

  defp rotate_facing(fc, :R) do
    case fc do
      :east -> :south
      :south -> :west
      :west -> :north
      :north -> :east
    end
  end

  defp rotate_facing(fc, :L) do
    case fc do
      :south -> :east
      :west -> :south
      :north -> :west
      :east -> :north
    end
  end

  defp next_cell(%{pos: {x, y}, facing: facing}, map) do
    next_cell({x, y}, facing, map, map.bounds)
  end

  defp next_cell({x, y}, facing, map, bounds) do
    next_pos = raw_move({x, y}, facing)

    next_pos = wrap_pos(next_pos, bounds)

    case Map.fetch(map, next_pos) do
      :error -> next_cell(next_pos, facing, map, bounds)
      {:ok, v} -> {next_pos, v}
    end
  end

  defp raw_move({x, y}, facing) do
    case facing do
      :east -> {x + 1, y}
      :west -> {x - 1, y}
      :north -> {x, y - 1}
      :south -> {x, y + 1}
    end
  end

  # TODO no recursion is needed here

  defp wrap_pos({x, y}, {_xl, xh, _yl, _yh} = bounds) when x > xh do
    wrap_pos({1, y}, bounds)
  end

  defp wrap_pos({x, y}, {xl, xh, _yl, _yh} = bounds) when x < xl do
    wrap_pos({xh, y}, bounds)
  end

  defp wrap_pos({x, y}, {_xl, _xh, _yl, yh} = bounds) when y > yh do
    wrap_pos({x, 1}, bounds)
  end

  defp wrap_pos({x, y}, {_xl, _xh, yl, yh} = bounds) when y < yl do
    wrap_pos({x, yh}, bounds)
  end

  defp wrap_pos(xy, _) do
    xy
  end

  defp max_x(list), do: Enum.reduce(list, &max_x/2)
  defp min_x(list), do: Enum.reduce(list, &min_x/2)
  defp max_y(list), do: Enum.reduce(list, &max_y/2)
  defp min_y(list), do: Enum.reduce(list, &min_y/2)

  defp max_x({a, _}, {b, _}), do: max(a, b)
  defp max_x({a, _}, b) when is_integer(b), do: max(a, b)
  defp min_x({a, _}, {b, _}), do: min(a, b)
  defp min_x({a, _}, b) when is_integer(b), do: min(a, b)
  defp max_y({_, a}, {_, b}), do: max(a, b)
  defp max_y({_, a}, b) when is_integer(b), do: max(a, b)
  defp min_y({_, a}, {_, b}), do: min(a, b)
  defp min_y({_, a}, b) when is_integer(b), do: min(a, b)

  @face_names ~w(
  a b c d
  e f g h
  i j k l
  m n o p)a

  def part_two({flat_map, moves}, square_size \\ 50) do
    map = compute_faces(flat_map, square_size)

    map = Map.put(map, :trans, get_translations(square_size))
    map = Map.put(map, :sz, square_size)

    init_pos = @face_names |> Enum.map(&{&1, 1, 1}) |> Enum.find(&Map.has_key?(map, &1))
    initial = %{facing: :east, pos: init_pos}

    state =
      Enum.reduce(moves, initial, fn move, state ->
        run_move_p2(move, state, map)
      end)

    %{facing: facing, pos: {face, x, y}} = state
    {x, y} = deproject(face, x, y, square_size)
    y * 1000 + 4 * x + facing_score(facing)
  end

  defp deproject(face, x, y, square_size) do
    helper = %{
      a: {0, 0},
      b: {1, 0},
      c: {2, 0},
      d: {3, 0},
      e: {0, 1},
      f: {1, 1},
      g: {2, 1},
      h: {3, 1},
      i: {0, 2},
      j: {1, 2},
      k: {2, 2},
      l: {3, 2},
      m: {0, 3},
      n: {1, 3},
      o: {2, 3},
      p: {3, 3}
    }

    {fx, fy} = Map.fetch!(helper, face)

    {flat_origin_x, flat_origin_y} = {fx * square_size, fy * square_size}
    {flat_origin_x + x, flat_origin_y + y}
  end

  defp compute_faces(map, square_size) do
    faces =
      for fy <- 0..3, fx <- 0..3 do
        test_coord = {1 + fx * square_size, 1 + fy * square_size}

        if Map.has_key?(map, test_coord) do
          {fx, fy}
        else
          nil
        end
      end
      |> Enum.zip(@face_names)
      |> Enum.filter(&(elem(&1, 0) != nil))

    Enum.flat_map(faces, fn {{fx, fy}, name} ->
      xl = 1 + fx * square_size
      xh = (fx + 1) * square_size
      yl = 1 + fy * square_size
      yh = (fy + 1) * square_size

      for x <- xl..xh, y <- yl..yh do
        {{name, x - (xl - 1), y - (yl - 1)}, Map.fetch!(map, {x, y})}
      end
    end)
    |> Map.new()
  end

  defp fetch_translation!(tls, face, facing) do
    for_face =
      case Map.fetch(tls, face) do
        {:ok, v} -> v
        :error -> raise "no translations for face #{inspect(face)} facing #{inspect(facing)}"
      end

    case Map.fetch(for_face, facing) do
      {:ok, v} -> v
      :error -> raise "no translations for face #{inspect(face)} facing #{inspect(facing)}"
    end
  end

  defp apply_translation(xy, {new_face, trans_x, trans_y, new_facing}) do
    x = get_coord(xy, trans_x)
    y = get_coord(xy, trans_y)
    {{new_face, x, y}, new_facing}
  end

  defp get_coord({x, _}, :x) do
    x
  end

  defp get_coord({_, y}, :y) do
    y
  end

  defp get_coord(_, {:set, n}) do
    n
  end

  defp get_coord({_, y}, {:invert_y, sz}) do
    sz - y + 1
  end

  defp get_coord({x, _}, {:invert_x, sz}) do
    sz - x + 1
  end

  # hardcoded version of translations.
  # we use the square size to know if we are in the test or in the actual input
  defp get_translations(4 = sz) do
    %{
      c: %{
        south: {:g, :x, {:set, 1}, :south}
      },
      g: %{
        east: {:l, {:invert_y, sz}, {:set, 1}, :south}
      },
      l: %{
        west: {:k, {:set, sz}, :y, :west}
      },
      k: %{
        south: {:e, {:invert_x, sz}, {:set, sz}, :north}
      },
      e: %{
        east: {:f, {:set, 1}, :y, :east}
      },
      f: %{
        north: {:c, {:set, 1}, :x, :east}
      }
    }
  end

  defp get_translations(50 = sz) do
    %{
      b: %{
        north: {:m, {:set, 1}, :x, :east},
        east: {:c, {:set, 1}, :y, :east},
        west: {:i, {:set, 1}, {:invert_y, sz}, :east},
        south: {:f, :x, {:set, 1}, :south}
      },
      m: %{
        west: {:b, :y, {:set, 1}, :south},
        south: {:c, :x, {:set, 1}, :south},
        east: {:j, :y, {:set, sz}, :north},
        north: {:i, :x, {:set, sz}, :north}
      },
      j: %{
        north: {:f, :x, {:set, sz}, :north},
        west: {:i, {:set, sz}, :y, :west},
        east: {:c, {:set, sz}, {:invert_y, sz}, :west},
        south: {:m, {:set, sz}, :x, :west}
      },
      f: %{
        east: {:c, :y, {:set, sz}, :north},
        west: {:i, :y, {:set, 1}, :south},
        south: {:j, :x, {:set, 1}, :south},
        north: {:b, :x, {:set, sz}, :north}
      },
      c: %{
        east: {:j, {:set, sz}, {:invert_y, sz}, :west},
        west: {:b, {:set, sz}, :y, :west},
        south: {:f, {:set, sz}, :x, :west},
        north: {:m, :x, {:set, sz}, :north}
      },
      i: %{
        south: {:m, :x, {:set, 1}, :south},
        west: {:b, {:set, 1}, {:invert_y, sz}, :east},
        north: {:f, {:set, 1}, :x, :east},
        east: {:j, {:set, 1}, :y, :east}
      }
    }
  end

  defp run_move_p2(move, state, map) do
    do_run_move_p2(move, state, map)
  end

  defp do_run_move_p2({:walk, n}, state, map) when n > 0 do
    case next_cell_p2(state, map) do
      {fxy, :ground, new_facing} ->
        state = %{state | pos: fxy, facing: new_facing}
        run_move_p2({:walk, n - 1}, state, map)

      {_, :wall, _} ->
        state
    end
  end

  defp do_run_move_p2({:walk, 0}, state, _) do
    state
  end

  defp do_run_move_p2(side, state, _map) when side in [:R, :L] do
    turn(state, side)
  end

  defp next_cell_p2(%{pos: {face, x, y}, facing: facing}, map) do
    next_cell_p2({face, x, y}, facing, map, map.trans)
  end

  defp next_cell_p2({face, x, y}, facing, map, trans) do
    {x2, y2} = next_xy = raw_move({x, y}, facing)

    next_pos = {face, x2, y2}

    case Map.fetch(map, next_pos) do
      :error ->
        translation = fetch_translation!(trans, face, facing)
        {new_pos, new_facing} = apply_translation(next_xy, translation)
        {new_pos, Map.fetch!(map, new_pos), new_facing}

      {:ok, v} ->
        {next_pos, v, facing}
    end
  end
end
