defmodule Aoe.Y22.Day15Test do
  use ExUnit.Case, async: true

  alias Aoe.Y22.Day15, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_15_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 15 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 15, "sample-1")
  #

  @sample_1 """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  test "verify 2022/15 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 26
    assert expected == Solution.part_one(problem, 10)
  end

  test "verify 2022/15 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 56_000_011
    assert expected == Solution.part_two(problem, 20)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2022/15 part one" do
  #   assert {:ok, @part_one_solution} == Aoe.run(2022, 15, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/15 part two" do
  #   assert {:ok, @part_two_solution} == Aoe.run(2022, 15, :part_two)
  # end
end
