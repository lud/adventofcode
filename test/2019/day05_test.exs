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

    cpu_123 = IntCPU.run(new_cpu, io: IOBuf.new([123]))
    assert {_, %{output: [123]}} = cpu_123.io

    cpu_456 = IntCPU.run(new_cpu, io: IOBuf.new([456]))
    assert {_, %{output: [456]}} = cpu_456.io
  end

  test "parsing modes" do
    # should not raise
    inspect(IntCPU.from_string("1002,4,3,4,33"))
  end

  @part_one_solution 9_938_601

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 5, :part_one)
  end

  test "test jumping" do
    cpu =
      IntCPU.from_string("""
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """)

    # The above example program uses an input instruction to ask for a single
    # number. The program will then output 999 if the input value is below 8,
    # output 1000 if the input value is equal to 8, or output 1001 if the input
    # value is greater than 8.

    test_num = fn num ->
      cpu = IntCPU.run(cpu, io: IOBuf.new([num]))
      {_, buf} = cpu.io
      [out] = buf.output
      out
    end

    assert 999 = test_num.(4)
    assert 999 = test_num.(5)
    assert 1000 = test_num.(8)
    assert 1001 = test_num.(9)
    assert 1001 = test_num.(1_000_000)
  end

  @part_two_solution 4_283_952

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 5, :part_two)
  end
end
