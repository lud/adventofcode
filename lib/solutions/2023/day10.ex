defmodule AdventOfCode.Y23.Day10 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(lines, _part) do
    Grid.parse_stream(lines, &parse_char/1)
  end

  @pipes [
    :S,
    :F,
    :"7",
    :J,
    :|,
    :L,
    :-
  ]

  defp parse_char("."), do: :ignore
  defp parse_char("S"), do: {:ok, :S}
  defp parse_char("F"), do: {:ok, :F}
  defp parse_char("7"), do: {:ok, :"7"}
  defp parse_char("J"), do: {:ok, :J}
  defp parse_char("|"), do: {:ok, :|}
  defp parse_char("L"), do: {:ok, :L}
  defp parse_char("-"), do: {:ok, :-}

  def part_one(grid) do
    {start_xy, :S} = Enum.find(grid, fn {_, v} -> v == :S end)

    neighs = connected_neighbours(start_xy, :S, grid)

    for xy_from <- neighs, xy_to <- neighs, xy_from != xy_to do
      try do
        bfs_path(grid, xy_from, xy_to, fn pos, grid ->
          pipe = Map.fetch!(grid, pos)
          connected_neighbours(pos, pipe, grid)
        end)
      catch
        :not_found -> 0
      end
    end
    |> Enum.sort(:desc)
    |> case do
      [{n, _}, {n, _} | _] -> div(n, 2) + 1
    end
  end

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
    {:found, x, seen} -> {x, seen}
  end

  defp bfs_path(map, [_ | _] = open, end_pos, get_neighs, round, seen) do
    neighs =
      open
      |> Enum.flat_map(fn pos -> Enum.map(get_neighs.(pos, map), fn xy -> {xy, pos} end) end)
      |> Enum.uniq()
      |> Enum.filter(fn {xy, _} -> not Map.has_key?(seen, xy) end)

    neighs_yxs = Enum.map(neighs, fn {xy, _} -> xy end)

    if end_pos in neighs_yxs do
      throw({:found, round, Map.merge(seen, Map.new(neighs))})
    end

    seen = Map.merge(seen, Map.new(neighs))

    bfs_path(map, neighs_yxs, end_pos, get_neighs, round + 1, seen)
  end

  defp bfs_path(_, [], _, _, _, _) do
    throw(:not_found)
  end

  defp find_neighbours(xy, pipe, grid) do
    cardinal_valid(xy, pipe) |> Enum.filter(fn xy -> Map.get(grid, xy) not in [nil, :S] end)
  end

  defp cardinal_valid(xy, :L), do: [move(xy, :n), move(xy, :e)]
  defp cardinal_valid(xy, :-), do: [move(xy, :w), move(xy, :e)]
  defp cardinal_valid(xy, :J), do: [move(xy, :w), move(xy, :n)]
  defp cardinal_valid(xy, :F), do: [move(xy, :s), move(xy, :e)]
  defp cardinal_valid(xy, :"7"), do: [move(xy, :w), move(xy, :s)]
  defp cardinal_valid(xy, :|), do: [move(xy, :n), move(xy, :s)]
  defp cardinal_valid(xy, :S), do: [move(xy, :n), move(xy, :e), move(xy, :w), move(xy, :s)]

  def move({x, y}, :n), do: {x, y - 1}
  def move({x, y}, :s), do: {x, y + 1}
  def move({x, y}, :w), do: {x - 1, y}
  def move({x, y}, :e), do: {x + 1, y}

  defp connected_neighbours(xy, pipe, grid) do
    find_neighbours(xy, pipe, grid)
  end

  links = [
    {:F, [:s, :e]},
    {:"7", [:w, :s]},
    {:J, [:w, :n]},
    {:|, [:n, :s]},
    {:L, [:n, :e]},
    {:-, [:e, :w]}
  ]

  for {pipe, dirs} <- links, dir <- dirs do
    defp links_to?(unquote(pipe), unquote(dir)), do: true
  end

  defp links_to?(_, _), do: false

  def part_two(grid) do
    {start_xy, :S} = Enum.find(grid, fn {_, v} -> v == :S end)

    neighs = connected_neighbours(start_xy, :S, grid)

    {loop_first, loop_last, seen} =
      for xy_from <- neighs, xy_to <- neighs do
        try do
          {len, seen} =
            bfs_path(grid, xy_from, xy_to, fn pos, grid ->
              pipe = Map.fetch!(grid, pos)
              connected_neighbours(pos, pipe, grid)
            end)

          {len, xy_from, xy_to, seen}
        catch
          :not_found -> {0, xy_from, xy_to, nil}
        end
      end
      |> Enum.sort_by(&elem(&1, 0), :desc)
      |> case do
        [{n, from, to, seen}, {n, _, _, _} | _] -> {from, to, seen}
      end

    loop_first_direction = [:n, :s, :w, :e] |> Enum.find(&(Grid.translate(start_xy, &1) == loop_first))

    loop_last_direction = [:n, :s, :w, :e] |> Enum.find(&(Grid.translate(start_xy, &1) == loop_last))

    start_type = Enum.find(@pipes, fn t -> links_to?(t, loop_first_direction) and links_to?(t, loop_last_direction) end)

    true = Map.fetch!(seen, loop_first)

    path = compute_full_path(seen, loop_last, [start_xy])

    # !! Replacing the grid with loop only

    grid = Map.new(path, fn xy -> {xy, Map.fetch!(grid, xy)} end)
    grid = Map.put(grid, start_xy, start_type)

    # Going over the map line by line.  For each line start at west and go over
    # positions, changing the side beween :in and :out if we cross a pipe, and
    # counting the empty positions when we are on the :in side.

    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)
    {xo, yo}

    count =
      Enum.reduce(ya..yo, 0, fn y, ext_cout ->
        {_, count, _} =
          Enum.reduce(xa..xo, {:out, ext_cout, nil}, fn x, {side, count, cut} ->
            pos = {x, y}

            case {cut, Map.get(grid, pos, nil), side} do
              # Keeping same side over dead ends or horizontal pipes
              {:F, :J, side} -> {side, count, nil}
              {:L, :"7", side} -> {side, count, nil}
              {cut, :-, side} -> {side, count, cut}
              # crossing pipes
              {:F, :"7", side} -> {otherside(side), count, nil}
              {:L, :J, side} -> {otherside(side), count, nil}
              {nil, :|, side} -> {otherside(side), count, nil}
              {nil, :F, side} -> {otherside(side), count, :F}
              {nil, :L, side} -> {otherside(side), count, :L}
              # counting inside positions, ignoring outside positions
              {_, nil, :in} -> {:in, count + 1, nil}
              {_, nil, :out} -> {:out, count, nil}
            end
          end)

        count
      end)

    count

    # "failed"
  end

  defp otherside(:out), do: :in
  defp otherside(:in), do: :out

  defp compute_full_path(seen, pos, acc) do
    case Map.fetch!(seen, pos) do
      {_, _} = xy -> compute_full_path(seen, xy, [pos | acc])
      true -> [pos | acc]
    end
  end
end
