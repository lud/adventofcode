defmodule AdventOfCode.Solutions.Y20.Day05Test do
  alias AdventOfCode.Solutions.Y20.Day05, as: Solution
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_5_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 5 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 5, "sample-1")
  #

  test "check parser" do
    assert 357 = Solution.seat_id("FBFBBFFRLR")
    assert 567 = Solution.seat_id("BFFFBBFRRR")
    assert 119 = Solution.seat_id("FFFBBBFRRR")
    assert 820 = Solution.seat_id("BBFFBBFRLL")
  end

  @part_one_solution 978

  test "verify 2020/5 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 5, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 727

  test "verify 2020/5 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 5, :part_two)
  end
end
