defmodule AdventOfCode.Solutions.Y19.Day11 do
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  @black 0
  @white 1

  def part_one(cpu) do
    cpu

    grid = %{}
    pos = {0, 0}
    dir = :n
    state = :painter

    io = fn
      :init ->
        {grid, pos, dir, state}

      {:input, {grid, pos, dir, state}} ->
        color = Map.get(grid, pos, @black)
        {color, {grid, pos, dir, state}}

      {:output, color, {grid, pos, dir, :painter}} ->
        grid = Map.put(grid, pos, color)

        # IO.puts("---------------")

        # Grid.print(Map.put(grid, pos, dir), fn
        #   :n -> ?^
        #   :w -> ?<
        #   :s -> ?v
        #   :e -> ?>
        #   1 -> ?#
        #   0 -> ?\s
        #   nil -> ?\s
        # end)

        {grid, pos, dir, :turner}

      {:output, rotation, {grid, pos, dir, :turner}} ->
        dir =
          case rotation do
            0 -> Grid.rotate_counter_clockwise(dir)
            1 -> Grid.rotate_clockwise(dir)
          end

        pos = Grid.translate(pos, dir)
        {grid, pos, dir, :painter}
    end

    grid = IntCPU.run(cpu, io: io).io |> elem(1) |> elem(0)
    map_size(grid)
  end

  # def part_two(cpu) do
  #   cpu
  # end
end
