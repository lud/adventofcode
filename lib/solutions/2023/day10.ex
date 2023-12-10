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
    open = [{start_xy, :S}]
    # closed = MapSet.new([])
    # {_, count} = search_loop(open, closed, 0, grid)
    # count

    neighs = connected_neighbours(start_xy, :S, grid)

    for {xy_from, _} <- neighs, {xy_to, _} <- neighs do
      try do
        bfs_path(grid, xy_from, xy_to, fn pos, grid ->
          pipe = Map.fetch!(grid, pos)
          connected_neighbours(pos, pipe, grid) |> Enum.map(&elem(&1, 0))
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

  defp search_loop(open, closed, count, grid) do
    discovered = Enum.flat_map(open, fn {xy, pipe} -> connected_neighbours(xy, pipe, grid) end)

    discovered = Enum.uniq(discovered)
    discovered = Enum.reject(discovered, fn {xy, _} -> MapSet.member?(closed, xy) end)

    count |> IO.inspect(label: ~S/count/)
    open_xys = Enum.map(discovered, fn {xy, _} -> xy end)
    closed = MapSet.union(closed, MapSet.new(open_xys))

    case discovered do
      [] -> {open, count}
      list -> search_loop(discovered, closed, count + 1, grid)
    end
  end

  defp connected_neighbours(xy, pipe, grid) do
    north = Grid.translate(xy, :n)
    south = Grid.translate(xy, :s)
    west = Grid.translate(xy, :w)
    east = Grid.translate(xy, :e)

    selected = []

    selected =
      with {:ok, north_pipe} <- Map.fetch(grid, north),
           true <- connects_from?(:n, pipe, north_pipe) do
        [{north, north_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, south_pipe} <- Map.fetch(grid, south),
           true <- connects_from?(:s, pipe, south_pipe) do
        [{south, south_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, west_pipe} <- Map.fetch(grid, west),
           true <- connects_from?(:w, pipe, west_pipe) do
        [{west, west_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, east_pipe} <- Map.fetch(grid, east),
           true <- connects_from?(:e, pipe, east_pipe) do
        [{east, east_pipe} | selected]
      else
        _ -> selected
      end

    selected
  end

  defp connects_from?(_, :S, _), do: true

  defp connects_from?(:n, start, from), do: links_to?(start, :n) and links_to?(from, :s)
  defp connects_from?(:s, start, from), do: links_to?(start, :s) and links_to?(from, :n)
  defp connects_from?(:w, start, from), do: links_to?(start, :w) and links_to?(from, :e)
  defp connects_from?(:e, start, from), do: links_to?(start, :e) and links_to?(from, :w)

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
    open = [{start_xy, :S}]
    # closed = MapSet.new([])
    # {_, count} = search_loop(open, closed, 0, grid)
    # count

    neighs = connected_neighbours(start_xy, :S, grid)

    {loop_first, loop_last, seen} =
      for {xy_from, _} <- neighs, {xy_to, _} <- neighs do
        try do
          {len, seen} =
            bfs_path(grid, xy_from, xy_to, fn pos, grid ->
              pipe = Map.fetch!(grid, pos)
              connected_neighbours(pos, pipe, grid) |> Enum.map(&elem(&1, 0))
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

    print_grid(grid)

    # Assuming the loop does not touch the borders of the map.  For each line of
    # the map
    # * We start at the leftmost position (west), and we are "outside" the loop.
    # * We go to east until we reach a loop position.
    # * Then we are "inside" the loop.
    # * We go to east.
    # * If this position pipe links to the west, we are still on the same
    #   segment pipe, so we are still "inside".
    # * If it does not link to west, we are now "outside" the loop.
    # * We continue towards east

    on_loop = Map.new(path, &{&1, true})

    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)
    {xo, yo}

    {count, debug} =
      Enum.reduce(ya..yo, {0, []}, fn y, {ext_cout, debug} ->
        IO.puts("===========")

        {_, count, debug, _} =
          Enum.reduce(xa..xo, {:out, ext_cout, debug, nil}, fn x, {side, count, debug, cut} ->
            pos = {x, y}

            case {side, Map.get(grid, pos, nil), cut} do
              {:out, nil, cut} ->
                {:out, count, [{pos, "O"} | debug], cut}

              {:in, nil, cut} ->
                {:in, count + 1, [{pos, "I"} | debug], cut}

              {:out, :F, nil} ->
                {:in, count, debug, :F}

              {side, :-, cut} ->
                {side, count, debug, cut}

              # F7 : F goes in, 7 goes out
              {:in, :"7", :F} ->
                {:out, count, debug, nil}

              {:out, :|, nil} ->
                {:in, count, debug, nil}

              {:in, :|, nil} ->
                {:out, count, debug, nil}

              {:in, :F, nil} ->
                {:out, count, debug, :F}

              # F7 : F goes out, 7 goes back in
              {:out, :"7", :F} ->
                {:in, count, debug, nil}

              {:in, :L, nil} ->
                {:out, count, debug, :L}

              # L7 : that is a cross, we are still out
              {:out, :"7", :L} ->
                {:out, count, debug, nil}

              # FJ : a cross
              {:in, :J, :F} ->
                {:in, count, debug, nil}

              {:out, :L, nil} ->
                {:in, count, debug, :L}

              # LJ : dead end, L goes in, J goes out
              {:in, :J, :L} ->
                {:out, count, debug, nil}

              # FJ : a cross
              {:out, :J, :F} ->
                {:out, count, debug, nil}

              # L7 : that is a cross,
              {:in, :"7", :L} ->
                {:in, count, debug, nil}

              # LJ : dead end, L goes in, J goes out
              {:out, :J, :L} ->
                {:in, count, debug, nil}

                # IO.puts("-------")
                # pipe |> IO.inspect(label: ~S/pipe/)
                # side |> IO.inspect(label: ~S/side/)
                # streak |> IO.inspect(label: ~S/streak/)

                # links_east = links_to?(pipe, :e)
                # links_west = links_to?(pipe, :w)

                # if links_west or (links_east and streak) do
                #   {side, count, debug, links_east}
                # else
                #   {switch_side(side), count, debug, links_east}
                # end
            end

            # if Map.has_key?(on_loop, pos) do
            #   {:in, count}
            # else
            #   {:out, count + 1}
            # end
          end)

        {count, debug}
      end)

    printable_inside = Map.new(debug)
    printable_grid = Map.merge(grid, printable_inside)
    print_grid(printable_grid)

    count |> dbg()

    # "failed"
  end

  defp switch_side(:out), do: :in
  defp switch_side(:in), do: :out

  defp print_grid(grid) do
    Grid.print_map(grid, fn
      nil -> " "
      "I" -> [IO.ANSI.bright(), "I", IO.ANSI.reset()]
      "O" -> [IO.ANSI.bright(), "O", IO.ANSI.reset()]
      a -> Atom.to_string(a)
    end)
  end

  defp compute_full_path(seen, pos, acc) do
    case Map.fetch!(seen, pos) do
      {_, _} = xy -> compute_full_path(seen, xy, [pos | acc])
      true -> [pos | acc]
    end
  end
end
