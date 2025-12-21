defmodule AdventOfCode.Solutions.Y19.Day07 do
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Permutations

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
    cpus = Enum.map(params, &provide_param(cpu, &1))
    loop(cpus, [], 0)
  end

  defp provide_param(cpu, param) do
    {:suspended, :ioread, cpu, cont} = IntCPU.run(cpu)
    cpu = cont.(cpu, param)
    IntCPU.resume(cpu)
  end

  defp loop([h | t], suspendeds, prev_output) do
    {:suspended, :ioread, cpu, cont} = h
    cpu = cont.(cpu, prev_output)
    {:suspended, {:iowrite, val}, cpu, cont} = IntCPU.resume(cpu)
    cpu = cont.(cpu)

    case IntCPU.resume(cpu) do
      {:suspended, :ioread, _, _} = sus -> loop(t, [sus | suspendeds], val)
      %{halted: true} = _cpu -> loop(t, suspendeds, val)
    end
  end

  defp loop([], [_ | _] = suspendeds, prev_output) do
    loop(:lists.reverse(suspendeds), [], prev_output)
  end

  defp loop([], [], final_output) do
    final_output
  end
end
