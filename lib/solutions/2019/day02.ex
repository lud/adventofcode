defmodule AdventOfCode.Solutions.Y19.Day02 do
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    run_gravity_assist(cpu, 12, 2)
  end

  defp run_gravity_assist(cpu, noun, verb) do
    cpu
    |> IntCPU.write(1, noun)
    |> IntCPU.write(2, verb)
    |> IntCPU.run()
    |> IntCPU.deref(0)
  end

  def part_two(cpu) do
    stream =
      Stream.flat_map(0..99, fn noun ->
        Stream.map(0..99, fn verb -> {noun, verb} end)
      end)

    stream
    |> Enum.find(fn {noun, verb} ->
      19_690_720 == run_gravity_assist(cpu, noun, verb)
    end)
    |> case do
      {noun, verb} -> 100 * noun + verb
    end
  end
end
