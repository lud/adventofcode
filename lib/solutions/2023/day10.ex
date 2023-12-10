defmodule AdventOfCode.Y23.Day10 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(lines, _part) do
    Grid.parse_stream(lines, &parse_char/1)
  end

  defp parse_char("."), do: :ignore
  defp parse_char("S"), do: {:ok, :S}
  defp parse_char("F"), do: {:ok, :F}
  defp parse_char("7"), do: {:ok, :"7"}
  defp parse_char("J"), do: {:ok, :J}
  defp parse_char("|"), do: {:ok, :|}
  defp parse_char("L"), do: {:ok, :L}
  defp parse_char("-"), do: {:ok, :-}

  def part_one(grid) do
    # We will travel along all pipes and keeping the longest possible track.
    # Ignoring all previous positions.  The solution will be the same point that
    # can be reached by two different paths.
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
    |> dbg()
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
      throw({:found, round, seen})
    end

    seen = Map.merge(seen, Map.new(neighs))

    bfs_path(map, neighs_yxs, end_pos, get_neighs, round + 1, seen)
  end

  defp bfs_path(_, [], _, _, _, _) do
    throw(:not_found)
  end

  defp search_loop(open, closed, count, grid) do
    discovered = Enum.flat_map(open, fn {xy, pipe} -> connected_neighbours(xy, pipe, grid) end)

    discovered = Enum.uniq(discovered) |> dbg()
    discovered = Enum.reject(discovered, fn {xy, _} -> MapSet.member?(closed, xy) end) |> dbg()

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
           true <- connects_from?(:north, pipe, north_pipe) do
        [{north, north_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, south_pipe} <- Map.fetch(grid, south),
           true <- connects_from?(:south, pipe, south_pipe) do
        [{south, south_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, west_pipe} <- Map.fetch(grid, west),
           true <- connects_from?(:west, pipe, west_pipe) do
        [{west, west_pipe} | selected]
      else
        _ -> selected
      end

    selected =
      with {:ok, east_pipe} <- Map.fetch(grid, east),
           true <- connects_from?(:east, pipe, east_pipe) do
        [{east, east_pipe} | selected]
      else
        _ -> selected
      end

    selected
  end

  defp connects_from?(_, :S, _), do: true

  defp connects_from?(:north, start, from), do: links_to?(start, :north) and links_to?(from, :south)
  defp connects_from?(:south, start, from), do: links_to?(start, :south) and links_to?(from, :north)
  defp connects_from?(:west, start, from), do: links_to?(start, :west) and links_to?(from, :east)
  defp connects_from?(:east, start, from), do: links_to?(start, :east) and links_to?(from, :west)

  links = [
    {:F, [:south, :east]},
    {:"7", [:west, :south]},
    {:J, [:west, :north]},
    {:|, [:north, :south]},
    {:L, [:north, :east]},
    {:-, [:east, :west]}
  ]

  for {pipe, dirs} <- links, dir <- dirs do
    defp links_to?(unquote(pipe), unquote(dir)), do: true
  end

  defp links_to?(_, _), do: false

  # def part_two(problem) do
  #   problem
  # end
end
