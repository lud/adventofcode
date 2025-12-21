defmodule AdventOfCode.Solutions.Y19.Day13 do
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    cpu
    |> IntCPU.run(io: IOBuf.new([]))
    |> IntCPU.outputs()
    |> Enum.chunk_every(3)
    |> Enum.reduce(%{}, fn [x, y, tile], grid ->
      Map.put(grid, {x, y}, tile)
    end)
    |> Grid.print(fn
      # is an empty tile. No game object appears in this tile.
      0 -> " "
      # is a wall tile. Walls are indestructible barriers.
      1 -> "|"
      # is a block tile. Blocks can be broken by the ball.
      2 -> "#"
      # is a horizontal paddle tile. The paddle is indestructible.
      3 -> "_"
      # is a ball tile. The ball moves diagonally and bounces off objects.
      4 -> "O"
    end)
    |> Enum.count(fn {_, t} -> t == 2 end)
  end

  # def part_two(cpu) do
  #   cpu
  # end
end
