defmodule AdventOfCode.Solutions.Y19.Day05 do
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    # Input diagnostic code `1` the ID for the ship's air conditioner unit.
    buf = IOBuf.new([1])

    cpu = IntCPU.run(cpu, io: buf)

    {_, buf} = cpu.io
    [solution | zeroes] = buf.output
    true = Enum.all?(zeroes, &(&1 == 0))
    solution
  end

  # def part_two(problem) do
  #   problem
  # end
end
