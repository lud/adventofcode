defmodule AdventOfCode.Solutions.Y24.Day16 do
  alias AdventOfCode.PathFinder.Multi
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    grid =
      input
      |> Input.stream!(trim: true)
      |> Grid.parse_lines(fn
        _, ?# ->
          {:ok, :wall}

        _, ?. ->
          :ignore

        xy, ?E ->
          send(self(), {:end, xy})
          {:ok, :end}

        xy, ?S ->
          send(self(), {:start, xy})
          {:ok, :start}
      end)
      |> elem(0)

    start = receive(do: ({:start, s} -> s))
    target = receive(do: ({:end, s} -> s))

    {grid, start, target}
  end

  def part_one({grid, start, target}) do
    {grid, start, target}
    {[{_, cost} | _], _} = Multi.best_paths(grid, {start, :e}, target, &explorer/3)
    cost
  end

  defp explorer(:neighbors, {xy, dir}, map) do
    forward = Grid.translate(xy, dir)

    rotations = [
      {{xy, Grid.rotate_clockwise(dir)}, 1000},
      {{xy, Grid.rotate_counter_clockwise(dir)}, 1000}
    ]

    case Map.get(map, forward) do
      :wall -> rotations
      v when v in [nil, :start, :end] -> [{{forward, dir}, 1} | rotations]
    end
  end

  defp explorer(:target?, {{x, y}, _dir}, {x, y}), do: true
  defp explorer(:target?, _, _), do: false

  def part_two({grid, start, target}) do
    {[{best_target, best_cost} | _] = bests_found, costs} =
      Multi.best_paths(grid, {start, :e}, target, &explorer/3)

    # In my input there is only one target with the best path. (For
    # this excercise, a target is xy+direction). I suspect it is
    # the case for anyone. But that target can be reached in multiple ways. .
    [_single] = Enum.filter(bests_found, fn {_, cost} -> cost == best_cost end)

    costs
    |> Multi.all_parents(best_target)
    |> Enum.uniq_by(fn {xy, _} -> xy end)
    |> length()
  end
end
