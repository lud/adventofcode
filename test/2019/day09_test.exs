defmodule AdventOfCode.Solutions.Y19.Day09Test do
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Solutions.Y19.Day09, as: Solution, warn: false
  alias AoC.Input, warn: false
  use ExUnit.Case, async: true

  describe "support for new operators and modes" do
    test "quine" do
      # this program should output itself
      ints = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
      cpu = IntCPU.new(ints)

      assert ints ==
               cpu
               |> IntCPU.run(io: IOBuf.new([]))
               |> IntCPU.outputs()
    end

    test "should output a 16 digit number" do
      # this program should output itself
      ints = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
      cpu = IntCPU.new(ints)

      assert [num] =
               cpu
               |> IntCPU.run(io: IOBuf.new([]))
               |> IntCPU.outputs()

      assert 16 = num |> Integer.digits() |> length()
    end
  end

  @part_one_solution 3_638_931_938

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 9, :part_one)
  end

  @part_two_solution 86025

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 9, :part_two)
  end
end
