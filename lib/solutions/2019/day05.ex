defmodule AdventOfCode.Solutions.Y19.Day05 do
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    # Input diagnostic code `1` the ID for the ship's air conditioner unit.
    run_with_input(cpu, 1)
  end

  def part_two(cpu) do
    run_with_input(cpu, 5)
  end

  defp run_with_input(cpu, input) do
    buf = IOBuf.new([input])
    cpu = IntCPU.run(cpu, io: buf)
    {_, buf} = cpu.io
    [solution | zeroes] = buf.output
    true = Enum.all?(zeroes, &(&1 == 0))
    solution
  end
end
