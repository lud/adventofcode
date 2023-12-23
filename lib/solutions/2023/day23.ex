defmodule AdventOfCode.Y23.Day23 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Grid.parse_stream(fn
      "#" -> :ignore
      o -> {:ok, o}
    end)
  end

  defmodule GridWrap do
    defstruct [:grid]

    defimpl Inspect do
      def inspect(%{grid: g}, _) do
        "Grid<#{map_size(g)}>"
      end
    end
  end

  def part_one(grid) do
    start_xy = {1, 0}
    "." = Map.fetch!(grid, start_xy)
    {xa, xo, ya, yo} = Grid.bounds(grid)

    # use Xo as we did not parse the walls, so the right border is not included
    target_xy = {xo, yo} |> dbg()
    "." = Map.fetch!(grid, target_xy)

    Grid.print_map(grid)

    grid |> Map.keys() |> Enum.max_by(fn {x, y} -> y end) |> IO.inspect()

    init = [{start_xy, ".", %GridWrap{grid: grid}, 0}]

    loop_longest(init, [], target_xy, [])
  end

  # def part_two(problem) do
  #   problem
  # end

  defp loop_longest([], [], target_xy, finish_counts) do
    Enum.max(finish_counts)
  end

  defp loop_longest([], [chunk | states_chunks], target_xy, finish_counts) do
    loop_longest(chunk, states_chunks, target_xy, finish_counts)
  end

  defp loop_longest([{:done, count} = done | t], states_chunks, target_xy, finish_counts) do
    loop_longest(t, states_chunks, target_xy, [count | finish_counts])
  end

  defp loop_longest([h | t], states_chunks, target_xy, finish_counts) do
    next_states = next_steps(h, target_xy)
    loop_longest(t, [next_states | states_chunks], target_xy, finish_counts)
  end

  defp next_steps({:done, _} = done, target_xy) do
    [done]
  end

  defp next_steps({xy, ground, wrap, n}, target_xy) do
    grid = wrap.grid
    next_wrap = %GridWrap{grid: Map.delete(grid, xy)}

    xy
    |> possible_neighs(ground)
    |> Enum.flat_map(fn
      ^target_xy ->
        [{:done, n + 1}]

      next_xy ->
        case Map.fetch(grid, next_xy) do
          {:ok, o} -> [{next_xy, o, next_wrap, n + 1}]
          :error -> []
        end
    end)
    |> case do
      [] -> []
      [single] -> next_steps(single, target_xy)
      more -> more
    end
  end

  defp possible_neighs(xy, "."), do: Grid.cardinal4(xy)
  defp possible_neighs(xy, "v"), do: [Grid.translate(xy, :s)]
  defp possible_neighs(xy, ">"), do: [Grid.translate(xy, :e)]
end
