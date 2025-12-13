defmodule AdventOfCode.Solutions.Y19.Day02 do
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(problem) do
    problem
    |> IntCPU.write(1, 12)
    |> IntCPU.write(2, 2)
    |> IntCPU.run()
    |> IntCPU.deref(0)
  end

  # def part_two(problem) do
  #   problem
  # end
end
