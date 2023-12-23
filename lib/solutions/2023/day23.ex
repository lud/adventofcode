defmodule AdventOfCode.Y23.Day23 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, :part_one) do
    input
    |> Grid.parse_stream(fn
      "#" -> :ignore
      o -> {:ok, o}
    end)
  end

  def parse_input(input, :part_two) do
    input
    |> Grid.parse_stream(fn
      "#" -> :ignore
      _ -> {:ok, "."}
    end)
  end

  def part_one(grid) do
    start_xy = {1, 0}
    "." = Map.fetch!(grid, start_xy)
    {_, xo, _, yo} = Grid.bounds(grid)

    # use Xo as we did not parse the walls, so the right border is not included
    target_xy = {xo, yo}
    "." = Map.fetch!(grid, target_xy)

    init = [{start_xy, ".", grid, 0}]
    loop_longest(init, [], target_xy, 0)
  end

  defp loop_longest([], [], _target_xy, best) do
    best
  end

  defp loop_longest([], [chunk | states_chunks], target_xy, best) do
    loop_longest(chunk, states_chunks, target_xy, best)
  end

  defp loop_longest([{:done, count} | t], states_chunks, target_xy, best) do
    loop_longest(t, states_chunks, target_xy, max(best, count))
  end

  defp loop_longest([h | t], states_chunks, target_xy, best) do
    next_states = next_steps(h, target_xy)
    loop_longest(t, [next_states | states_chunks], target_xy, best)
  end

  defp next_steps({xy, ground, grid, n}, target_xy) do
    next_grid = Map.delete(grid, xy)

    xy
    |> possible_neighs(ground)
    |> Enum.flat_map(fn
      ^target_xy ->
        [{:done, n + 1}]

      next_xy ->
        case Map.fetch(grid, next_xy) do
          {:ok, o} -> [{next_xy, o, next_grid, n + 1}]
          :error -> []
        end
    end)
    |> case do
      [] -> []
      [{:done, _} = done] -> [done]
      [single] -> next_steps(single, target_xy)
      more -> more
    end
  end

  defp possible_neighs(xy, "."), do: Grid.cardinal4(xy)
  defp possible_neighs(xy, "v"), do: [Grid.translate(xy, :s)]
  defp possible_neighs(xy, ">"), do: [Grid.translate(xy, :e)]

  def part_two(grid) do
    start_xy = {1, 0}
    "." = Map.fetch!(grid, start_xy)
    {_, xo, _, yo} = Grid.bounds(grid)

    # use Xo as we did not parse the walls, so the right border is not included
    target_xy = {xo, yo}
    "." = Map.fetch!(grid, target_xy)

    graph = explore_nodes([start_xy, target_xy], start_xy, target_xy, %{}, %{}, grid)

    init = [{start_xy, 0, %{}}]
    longest_path(init, target_xy, 0, graph)
  end

  defp longest_path([], _target_xy, best, _graph) do
    best
  end

  defp longest_path(states, target_xy, best, graph) do
    {new_states, best} =
      states
      |> Enum.flat_map(fn state -> go_hike(state, target_xy, graph) end)
      |> Enum.flat_map_reduce(best, fn
        {:done, n}, best -> {[], max(n, best)}
        other, best -> {[other], best}
      end)

    # There is too many possible paths so we take a change and keep the bests
    new_states =
      Enum.sort_by(new_states, fn {_, n, _} -> n end, :desc)
      |> Enum.take(3_000)

    longest_path(new_states, target_xy, best, graph)
  end

  defp go_hike({xy, n, seen}, target_xy, graph) do
    graph
    |> Map.fetch!(xy)
    |> Enum.flat_map(fn
      {^target_xy, dist} -> [{:done, n + dist}]
      {next_xy, dist} when not is_map_key(seen, next_xy) -> [{next_xy, n + dist, Map.put(seen, next_xy, true)}]
      _ -> []
    end)
  end

  # -- Generate graph nodes ---------------------------------------------------

  defp explore_nodes([h | t], start_xy, target_xy, graph, seen, grid) when is_map_key(seen, h) do
    explore_nodes(t, start_xy, target_xy, graph, seen, grid)
  end

  defp explore_nodes([h | t], start_xy, target_xy, graph, seen, grid) do
    next_nodes = next_nodes(h, start_xy, target_xy, grid) |> Map.new()
    graph = Map.update(graph, h, next_nodes, fn links -> Map.merge(links, next_nodes, &merger/3) end)

    graph =
      Enum.reduce(next_nodes, graph, fn {link_xy, dist}, graph ->
        Map.update(graph, link_xy, %{h => dist}, fn links -> Map.merge(links, %{h => dist}, &merger/3) end)
      end)

    seen = Map.put(seen, h, true)
    new = next_nodes |> Map.keys()

    explore_nodes(new ++ t, start_xy, target_xy, graph, seen, grid)
  end

  defp explore_nodes([], _, _, graph, _, _), do: graph

  defp merger(_, dist, dist), do: dist

  defp next_nodes(xy, start_xy, target_xy, grid) do
    neighs(xy, grid)
    |> Enum.map(fn next_xy -> follow_trail(next_xy, xy, 1, start_xy, target_xy, grid) end)
  end

  defp neighs(xy, grid) do
    xy
    |> Grid.cardinal4()
    |> Enum.flat_map(fn next_xy ->
      case Map.fetch(grid, next_xy) do
        {:ok, "."} -> [next_xy]
        :error -> []
      end
    end)
  end

  defp follow_trail(start_xy, _prev_xy, n, start_xy, _target_xy, _grid) do
    {start_xy, n}
  end

  defp follow_trail(target_xy, _prev_xy, n, _start_xy, target_xy, _grid) do
    {target_xy, n}
  end

  defp follow_trail(xy, prev_xy, n, start_xy, target_xy, grid) do
    case neighs(xy, grid) do
      [^prev_xy, next_xy] -> follow_trail(next_xy, xy, n + 1, start_xy, target_xy, grid)
      [next_xy, ^prev_xy] -> follow_trail(next_xy, xy, n + 1, start_xy, target_xy, grid)
      [_, _, _ | _] -> {xy, n}
    end
  end
end
