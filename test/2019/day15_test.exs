defmodule AdventOfCode.Solutions.Y19.Day15Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day15, as: Solution, warn: false
  use ExUnit.Case, async: true

  @part_one_solution 236

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 15, :part_one)
  end

  @part_two_solution 368

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 15, :part_two)
  end
end
