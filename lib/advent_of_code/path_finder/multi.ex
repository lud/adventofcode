defmodule AdventOfCode.PathFinder.Multi do
  @doc """
  Returns all valid targets with their associated cost. Returns the accumulated
  costs as well to provide a way to reconstruct the paths.
  """
  def best_paths(map, start_state, target_pos, callback) do
    best_paths(map, [{start_state, 0}], target_pos, callback, _costs = %{start_state => [{:"$path_start", 0}]})
  end

  defp best_paths(map, [_ | _] = open, target, callback, costs) do
    {new_open, costs} =
      open
      |> Enum.flat_map(fn {pos_state, prev_cost} -> neighbors_with_costs(pos_state, prev_cost, map, callback) end)
      |> Enum.reduce({[], costs}, fn {pos_state, {prev, cost}}, {new_open, costs} ->
        {_new_open, _costs} =
          case Map.get(costs, pos_state) do
            [{_, prev_cost} | _] when cost < prev_cost ->
              # In this case we have already seen that neighbor, but we found it
              # with a better cost. We should update all other positions that
              # have it as their "prev" so reduce their cost by the difference,
              # recursively.
              #
              # For now we will just put it again on the open list and let the
              # algorithm start over from those positions.
              #
              # Also we store a list of previous points, since multiple paths
              # can be the lowest path.
              {[{pos_state, cost} | new_open], %{costs | pos_state => [{prev, cost}]}}

            [{_, prev_cost} | _] when cost > prev_cost ->
              {new_open, costs}

            [{p, prev_cost} | _] = keep when cost == prev_cost and p != prev ->
              # We found another entrypoint with the same cost, we keep both
              # old and new in the list
              {new_open, %{costs | pos_state => [{prev, cost} | keep]}}

            nil ->
              {[{pos_state, cost} | new_open], Map.put(costs, pos_state, [{prev, cost}])}
          end
      end)

    best_paths(map, new_open, target, callback, costs)
  end

  defp best_paths(_map, [] = _open, target, callback, costs) do
    bests =
      costs
      |> Enum.filter(fn {pos_state, _} -> target?(pos_state, target, callback) end)
      |> Enum.map(fn {pos_state, [{_, cost} | _]} -> {pos_state, cost} end)
      |> Enum.sort_by(fn {_pos_state, cost} -> cost end)

    {bests, costs}
  end

  @doc """
  Returns all parent states recusively. As there could be multiple parents to a
  position, no particular order is guaranteed.
  """
  def all_parents(costs, pos_state) do
    all_parents(costs, pos_state, MapSet.new())
  end

  defp all_parents(costs, pos_state, set) do
    {:ok, prevs} = Map.fetch(costs, pos_state)

    set =
      Enum.reduce(prevs, set, fn
        {:"$path_start", _}, set -> set
        {prev, _cost}, set -> all_parents(costs, prev, set)
      end)

    MapSet.put(set, pos_state)
  end

  defp neighbors_with_costs(pos_state, prev_cost, map, callback) do
    neighs = callback.(:neighbors, pos_state, map)
    Enum.map(neighs, fn {neight_state, cost} -> {neight_state, {pos_state, cost + prev_cost}} end)
  end

  defp target?(pos_state, target, callback) do
    callback.(:target?, pos_state, target)
  end
end
