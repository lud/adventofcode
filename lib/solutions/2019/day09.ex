defmodule AdventOfCode.Solutions.Y19.Day09 do
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    IntCPU.run(cpu, io: IOBuf.new([1])) |> IntCPU.outputs() |> hd()
  end

  def part_two(cpu) do
    IntCPU.run(cpu, io: IOBuf.new([2])) |> IntCPU.outputs() |> hd()
  end
end
