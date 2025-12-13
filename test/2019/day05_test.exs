defmodule AdventOfCode.Solutions.Y19.Day05Test do
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Solutions.Y19.Day05, as: Solution, warn: false
  alias AoC.Input, warn: false
  use ExUnit.Case, async: true

  test "outputs the input" do
    new_cpu =
      IntCPU.from_string(~S"""
      3,0,4,0,99
      """)

    io = fn
      {:input, buf} -> IOBuf.read(buf)
      {:output, val, buf} -> IOBuf.write(buf, val)
    end

    cpu_123 = IntCPU.run(new_cpu, io: {io, IOBuf.new([123])})
    assert {_, %{output: [123]}} = cpu_123.io

    cpu_456 = IntCPU.run(new_cpu, io: {io, IOBuf.new([456])})
    assert {_, %{output: [456]}} = cpu_456.io
  end

  # @part_one_solution CHANGE_ME
  #
  # test "part one solution" do
  #   assert {:ok, @part_one_solution} == AoC.run(2019, 5, :part_one)
  # end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2019, 5, :part_two)
  # end
end
