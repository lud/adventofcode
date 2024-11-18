defmodule AdventOfCode.Solutions.Y15.Day05Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day05, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 5
  #
  #     mix test test/2015/day5_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 5 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-5-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 5, "sample")
  #
  # Good luck!

  test "part one example" do
    assert Solution.nice?("ugknbfddgicrmopn")
    assert Solution.nice?("aaa")
    refute Solution.nice?("jchzalrnumimnmhp")
    refute Solution.nice?("haegwjzuvuyypxyu")
    refute Solution.nice?("dvszwmarrgswjxmb")
  end

  @part_one_solution 258

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 5, :part_one)
  end

  @part_two_solution 53

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 5, :part_two)
  end
end
