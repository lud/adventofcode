defmodule AdventOfCode.Solutions.Y19.Day07 do
  alias AdventOfCode.Permutations
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    0..4
    |> Permutations.of()
    |> Stream.map(fn perm -> to_thrusters_simple(cpu, perm, 0) end)
    |> Enum.max()
  end

  defp to_thrusters_simple(cpu, [h | t], prev_output) do
    {_, buf} = IntCPU.run(cpu, io: IOBuf.new([h, prev_output])).io
    [out] = buf.output
    to_thrusters_simple(cpu, t, out)
  end

  defp to_thrusters_simple(_, [], prev_output) do
    prev_output
  end

  def part_two(cpu) do
    5..9
    |> Permutations.of()
    |> Stream.map(fn perm -> to_thrusters_feedback(cpu, perm) end)
    |> Enum.max()
  end

  defp to_thrusters_feedback(cpu, params) do
    cpus = Enum.map(params, &provide_param(cpu, &1)) |> dbg()

    # {_, buf} = IntCPU.run(cpu, io: IOBuf.new([h, prev_output])).io
    # [out] = buf.output
    # to_thrusters_feedback(cpu, t, out)
  end

  defp provide_param(cpu, param) do
    {:ioread, cpu} = IntCPU.run(cpu)
    IntCPU.resume_read(cpu, param)
  end
end
