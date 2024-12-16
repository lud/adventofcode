defmodule AdventOfCode.Solutions.Y24.Day16 do
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
    [{_, cost, _} | _] = Grid.lowest_path(grid, {start, :e}, target, &explorer/3)
    cost
  end

  defp explorer(:neighbors, {xy, dir}, map) do
    xy |> IO.inspect(label: "xy")
    dir |> IO.inspect(label: "dir")
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
    [{_target_state, best_cost, path} | _] =
      best_paths = Grid.lowest_path(grid, {start, :e}, target, &explorer/3) |> dbg()

    best_cost |> dbg()

    # In my input there is only one best path. I suspect it is the case for anyone
    [_single] = Enum.filter(best_paths, fn {_, cost, _} -> cost == best_cost end)

    grid
    |> Map.merge(Map.new(path, fn {{x, y}, _} -> {{x, y}, :o} end))
    |> Grid.print(fn
      :n -> ?^
      :e -> ?>
      :w -> ?<
      :s -> ?v
      :wall -> ?#
      nil -> ?.
      :o -> ?o
    end)

    path
    |> Enum.uniq_by(fn {xy, _dir} -> xy end)
    |> length()
  end
end
