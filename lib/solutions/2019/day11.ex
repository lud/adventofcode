defmodule AdventOfCode.Solutions.Y19.Day11 do
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  @black 0
  @white 1

  def part_one(cpu) do
    map_size(run_robot(cpu, @black))
  end

  def part_two(cpu) do
    grid = run_robot(cpu, @white)

    grid
    |> Grid.format(fn
      :n -> ?^
      :w -> ?<
      :s -> ?v
      :e -> ?>
      1 -> ?#
      0 -> ?\s
      nil -> ?\s
    end)
    |> IO.iodata_to_binary()
    |> String.split("\n")
    |> Enum.map_join("\n", &String.trim_trailing/1)
    |> tap(&IO.puts/1)
  end

  defp run_robot(cpu, init_color) do
    pos = {0, 0}
    grid = %{}
    dir = :n
    state = :painter

    io = fn
      :init ->
        {grid, pos, dir, state}

      {:input, {grid, pos, dir, state}} ->
        default =
          case pos do
            {0, 0} -> init_color
            _ -> @black
          end

        color = Map.get(grid, pos, default)
        {color, {grid, pos, dir, state}}

      {:output, color, {grid, pos, dir, :painter}} ->
        grid = Map.put(grid, pos, color)
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

    _grid = IntCPU.run(cpu, io: io).io |> elem(1) |> elem(0)
  end
end
