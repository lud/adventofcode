defmodule AdventOfCode.Y15.Day16Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day16, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 16
  #
  #     mix test test/2015/day16_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 16 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-16-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 16, "sample")
  #
  # Good luck!

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 40

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 16, :part_one)
  end

  @part_two_solution 241

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 16, :part_two)
  end
end
