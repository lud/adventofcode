defmodule AdventOfCode.Y23.Day21 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(&{:ok, &1})
  end

  def part_one(grid) when is_map(grid) do
    part_one({grid, 64})
  end

  def part_one({grid, max_steps}) do
    # Note
    #
    # We do not want the totality of reachable tiles in 64 steps or less, only
    # those that can be reached after exactly 64 steps.
    pos =
      Enum.find_value(grid, fn
        {xy, "S"} = start -> xy
        _ -> false
      end)

    grid = Map.put(grid, pos, ".")

    loop([pos], 1, max_steps, grid)
  end

  # def part_two(problem) do
  #   problem
  # end

  defp loop(open, step, max_steps, grid) when step > max_steps do
    length(open)
  end

  defp loop(open, step, max_steps, grid) do
    new_open =
      Enum.flat_map(open, fn pos ->
        pos
        |> Grid.cardinal4()
        |> Enum.map(&{&1, Map.get(grid, &1)})
        |> Enum.filter(fn
          {xy, "."} -> true
          _ -> false
        end)
        |> Enum.map(&elem(&1, 0))
      end)
      |> Enum.uniq()

    IO.puts("after step #{step}")

    grid
    |> Map.merge(Map.new(open, fn xy -> {xy, "O"} end))
    |> Grid.print_map()

    loop(new_open, step + 1, max_steps, grid)
  end
end
