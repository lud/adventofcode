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
    Grid.lowest_path(grid, {start, :e}, target, &explorer/3)
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

  # def part_two(problem) do
  #   problem
  # end
end
