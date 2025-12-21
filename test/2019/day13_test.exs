defmodule AdventOfCode.Solutions.Y19.Day13Test do
  alias AdventOfCode.Solutions.Y19.Day13, as: Solution, warn: false
  alias AoC.Input, warn: false
  use ExUnit.Case, async: true

  @part_one_solution 376

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 13, :part_one)
  end

  @part_two_solution 18509

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 13, :part_two)
  end
end
